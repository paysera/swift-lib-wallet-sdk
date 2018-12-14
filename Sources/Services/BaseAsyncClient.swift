import Alamofire
import ObjectMapper
import PromiseKit

public class BaseAsyncClient {
    
    let sessionManager: SessionManager
    let publicWalletApiClient: PublicWalletApiClient?
    let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol?
    
    var requestsQueue = [ApiRequest]()
    var timeIsSyncing = false
    
    init(sessionManager: SessionManager,
         publicWalletApiClient: PublicWalletApiClient? = nil,
         serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol? = nil) {
        
        self.sessionManager = sessionManager
        self.publicWalletApiClient = publicWalletApiClient
        self.serverTimeSynchronizationProtocol = serverTimeSynchronizationProtocol
    }
    
    public func cancelAllOperations() {
        sessionManager.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    func createRequest<T: ApiRequest, R: URLRequestConvertible>(_ endpoint: R) -> T {
        return T.init(pendingPromise: Promise<Any>.pending(),
                      requestEndPoint: endpoint
        )
    }
    
    func createPromise<T: Mappable>(body: Any) -> Promise<T> {
        
        guard let object = Mapper<T>().map(JSONString: body as! String) else {
            return Promise(error: mapError(body: body, statusCode: nil))
        }
        return Promise.value(object)
    }
    
    private func createPromiseWithArrayResult<T: Mappable>(body: Any) -> Promise<[T]> {
        guard let objects = Mapper<T>().mapArray(JSONString: (body as! String)) else {
            return Promise(error: mapError(body: body, statusCode: nil))
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
            sessionManager
                .request(apiRequest.requestEndPoint)
                .responseData { response in
                    
                    let responseData = String(data: response.data!, encoding: .utf8)
                    let json = try! JSONSerialization.jsonObject(with: response.data!, options: [])
                    
                    guard let statusCode = response.response?.statusCode else {
                        let error = self.mapError(body: json, statusCode: nil)
                        apiRequest.pendingPromise.resolver.reject(error)
                        return
                    }
                    if statusCode >= 200 && statusCode < 300 {
                        apiRequest.pendingPromise.resolver.fulfill(responseData as Any)
                        return
                    }
                    let error = self.mapError(body: json, statusCode: statusCode)
                    
                    if statusCode == 401 && error.isInvalidTimestamp() {
                        self.syncTimestamp(apiRequest, error)
                        return
                    }
                    apiRequest.pendingPromise.resolver.reject(error)
            }
        }
        
    }
    
    func syncTimestamp(_ apiRequest: ApiRequest, _ error: PSWalletApiError) {
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
    
    func mapError(body: Any?, statusCode: Int?) -> PSWalletApiError {
        
        if let apiError = Mapper<PSWalletApiError>().map(JSONObject: body) {
            
            apiError.statusCode = statusCode
            return apiError
        }
        
        return PSWalletApiError.unknown()
    }
}
