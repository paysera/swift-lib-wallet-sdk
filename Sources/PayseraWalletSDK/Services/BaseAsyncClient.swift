import Foundation
import Alamofire
import ObjectMapper
import PromiseKit
import PayseraCommonSDK

public class BaseAsyncClient {
    let session: Session
    let publicWalletApiClient: PublicWalletApiClient?
    let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol?
    let logger: PSLoggerProtocol?
    
    let lockQueue = DispatchQueue(label: String(describing: BaseAsyncClient.self), attributes: [])
    
    var requestsQueue = [ApiRequest]()
    var timeIsSyncing = false
    
    init(
        session: Session,
        publicWalletApiClient: PublicWalletApiClient? = nil,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol? = nil,
        logger: PSLoggerProtocol?
    ) {
        self.session = session
        self.publicWalletApiClient = publicWalletApiClient
        self.serverTimeSynchronizationProtocol = serverTimeSynchronizationProtocol
        self.logger = logger
    }
    
    public func cancelAllOperations() {
        session.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    func createRequest<T: ApiRequest, R: URLRequestConvertible>(_ endpoint: R) -> T {
        return T.init(
            pendingPromise: Promise<String>.pending(),
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
    
    func doRequest<RC: URLRequestConvertible>(requestRouter: RC) -> Promise<Void> {
        let request = createRequest(requestRouter)
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .asVoid()
    }
    
    func makeRequest(apiRequest: ApiRequest) {
        guard let urlRequest = apiRequest.requestEndPoint.urlRequest else { return }
        
        lockQueue.async {
            guard !self.timeIsSyncing else {
                self.requestsQueue.append(apiRequest)
                return
            }
            
            self.logger?.log(level: .DEBUG, message: "--> \(urlRequest.url!.absoluteString)")
            self.session
                .request(apiRequest.requestEndPoint)
                .responseData { response in
                    guard let urlResponse = response.response else {
                        apiRequest.pendingPromise.resolver.reject(PSApiError.noInternet())
                        return
                    }
                    
                    if let error = response.error, error.isCancelled {
                        apiRequest.pendingPromise.resolver.reject(PSApiError.cancelled())
                        return
                    }
                    
                    let statusCode = urlResponse.statusCode
                    let logMessage = "<-- \(urlRequest.url!.absoluteString) \(statusCode)"
                    
                    let responseString: String! = String(data: response.data ?? Data(), encoding: .utf8)
                    if 200 ... 299 ~= statusCode {
                        self.logger?.log(level: .DEBUG, message: logMessage, response: urlResponse)
                        apiRequest.pendingPromise.resolver.fulfill(responseString)
                        return
                    }
                    let error = self.mapError(jsonString: responseString, statusCode: statusCode)
                    self.logger?.log(level: .ERROR, message: logMessage, response: urlResponse, error: error)
                    if statusCode == 401 && error.isInvalidTimestamp() {
                        self.syncTimestamp(apiRequest, error)
                        return
                    }
                    apiRequest.pendingPromise.resolver.reject(error)
            }
        }
        
    }
    
    func syncTimestamp(_ apiRequest: ApiRequest, _ error: PSApiError) {
        guard let publicWalletApiClient = publicWalletApiClient else {
            apiRequest.pendingPromise.resolver.reject(error)
            return
        }
        
        lockQueue.async {
            self.requestsQueue.append(apiRequest)
            guard !self.timeIsSyncing else {
                return
            }
            
            self.timeIsSyncing = true
            
            publicWalletApiClient
                .getServerInformation()
                .done(on: self.lockQueue) { serverInformation in
                    self.serverTimeSynchronizationProtocol?.serverTimeDifferenceRefreshed(diff: serverInformation.timeDiff)
                    self.timeIsSyncing = false
                    self.resumeQueue()
                }
                .catch(on: self.lockQueue) { error in
                    self.timeIsSyncing = false
                    self.cancelQueue(error: error)
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
        let error: PSApiError!
        if statusCode >= 500, statusCode < 600 {
            error = PSApiError.internalServerError()
        } else {
            error = Mapper<PSApiError>().map(JSONString: jsonString) ?? PSApiError.mapping(json: jsonString)
        }
        
        error.statusCode = statusCode
        return error
    }
}
