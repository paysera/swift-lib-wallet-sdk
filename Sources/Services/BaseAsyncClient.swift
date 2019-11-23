import Alamofire
import ObjectMapper
import PromiseKit
import PayseraCommonSDK

public class BaseAsyncClient {
    let sessionManager: SessionManager
    let publicWalletApiClient: PublicWalletApiClient?
    let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol?
    let logger: PSLoggerProtocol?
    
    var requestsQueue = [ApiRequest]()
    var timeIsSyncing = false
    
    init(
        sessionManager: SessionManager,
        publicWalletApiClient: PublicWalletApiClient? = nil,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol? = nil,
        logger: PSLoggerProtocol?
    ) {
        self.sessionManager = sessionManager
        self.publicWalletApiClient = publicWalletApiClient
        self.serverTimeSynchronizationProtocol = serverTimeSynchronizationProtocol
        self.logger = logger
    }
    
    public func cancelAllOperations() {
        sessionManager.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    func createRequest<T: ApiRequest, R: URLRequestConvertible>(_ endpoint: R) -> T {
        return T.init(pendingPromise: Promise<String>.pending(),
                      requestEndPoint: endpoint
        )
    }
    
    func createPromise<T: Mappable>(jsonString: String) -> Promise<T> {
        guard let object = Mapper<T>().map(JSONString: jsonString) else {
            return Promise(error: PSApiError.mapping(json: jsonString))
        }
        return Promise.value(object)
    }
    
    private func createPromiseWithArrayResult<T: Mappable>(jsonString: String) -> Promise<[T]> {
        guard let objects = Mapper<T>().mapArray(JSONString: jsonString) else {
            return Promise(error: PSApiError.mapping(json: jsonString))
        }
        return Promise.value(objects)
    }
    
    func createPromise(body: Any) -> Promise<String> {
        return Promise.value(body as! String)
    }
    
    func doRequest<RC: URLRequestConvertible, E: Mappable>(requestRouter: RC) -> Promise<[E]> {
        let request = createRequest(requestRouter)
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromiseWithArrayResult)
    }
    
    func doRequest<RC: URLRequestConvertible, E: Mappable>(requestRouter: RC) -> Promise<E> {
        let request = createRequest(requestRouter)
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    func makeRequest(apiRequest: ApiRequest) {
        let lockQueue = DispatchQueue(label: String(describing: self), attributes: [])
        lockQueue.sync {
            guard !timeIsSyncing else {
                requestsQueue.append(apiRequest)
                return
            }
            self.logger?.log(level: .DEBUG, message: "--> \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString)")
            sessionManager
                .request(apiRequest.requestEndPoint)
                .responseData { response in
                    var logMessage = "<-- \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString)"
                    if let statusCode = response.response?.statusCode {
                        logMessage += " (\(statusCode))"
                    }
                    
                    self.logger?.log(level: .DEBUG, message: logMessage)
                    
                    if let error = response.error, error.isCancelled {
                        apiRequest.pendingPromise.resolver.reject(PSApiError.cancelled())
                        return
                    }
                    
                    guard let statusCode = response.response?.statusCode else {
                        apiRequest.pendingPromise.resolver.reject(PSApiError.noInternet())
                        return
                    }
                    
                    let responseString: String! = String(data: response.data ?? Data(), encoding: .utf8)
                    if statusCode >= 200 && statusCode < 300 {
                        apiRequest.pendingPromise.resolver.fulfill(responseString)
                        return
                    }
                    let error = self.mapError(jsonString: responseString, statusCode: statusCode)
                    if statusCode == 401 && error.isInvalidTimestamp() {
                        self.syncTimestamp(apiRequest, error)
                        return
                    }
                    apiRequest.pendingPromise.resolver.reject(error)
            }
        }
        
    }
    
    func syncTimestamp(_ apiRequest: ApiRequest, _ error: PSApiError) {
        let lockQueue = DispatchQueue(label: String(describing: self), attributes: [])
        lockQueue.sync {
            requestsQueue.append(apiRequest)
            guard !timeIsSyncing else {
                return
            }
            guard let publicWalletApiClient = self.publicWalletApiClient else {
                apiRequest.pendingPromise.resolver.reject(error)
                return
            }
            timeIsSyncing = true
            
            publicWalletApiClient
                .getServerInformation()
                .done { serverInformation in
                    self.serverTimeSynchronizationProtocol?.serverTimeDifferenceRefreshed(diff: serverInformation.timeDiff)
                    lockQueue.sync {
                        self.timeIsSyncing = false
                        self.resumeQueue()
                    }
                }.catch { error in
                    lockQueue.sync {
                        self.timeIsSyncing = false
                        self.cancelQueue(error: error)
                    }
            }
        }
    }
    
    func resumeQueue() {
        for request in requestsQueue {
            makeRequest(apiRequest: request)
        }
        requestsQueue.removeAll()
    }
    
    func cancelQueue(error: Error) {
        for requests in requestsQueue {
            requests.pendingPromise.resolver.reject(error)
        }
        requestsQueue.removeAll()
    }
    
    func mapError(jsonString: String, statusCode: Int) -> PSApiError {
        let apiError = Mapper<PSApiError>().map(JSONString: jsonString) ?? PSApiError.mapping(json: jsonString)
        apiError.statusCode = statusCode
        return apiError
    }
}
