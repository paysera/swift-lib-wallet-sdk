import Alamofire
import Foundation
import ObjectMapper
import PayseraCommonSDK
import PromiseKit

public class BaseAsyncClient {
    let session: Session
    let logger: PSLoggerProtocol?
    
    let workQueue = DispatchQueue(label: String(describing: BaseAsyncClient.self))
    var requestsQueue = [ApiRequest]()
    var timeIsSyncing = false
    
    private let publicWalletApiClient: PublicWalletApiClient?
    private let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol?
    
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
        session.cancelAllRequests()
    }
    
    func doRequest<RC: URLRequestConvertible, E: Mappable>(requestRouter: RC) -> Promise<[E]> {
        let request = createRequest(requestRouter)
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
            .map(on: workQueue) { jsonString in
                guard let objects = Mapper<E>().mapArray(JSONString: jsonString) else {
                    throw PSApiError.mapping(json: jsonString)
                }
                return objects
            }
    }
    
    func doRequest<RC: URLRequestConvertible, E: Mappable>(requestRouter: RC) -> Promise<E> {
        let request = createRequest(requestRouter)
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
            .map(on: workQueue) { jsonString in
                guard let object = Mapper<E>().map(JSONString: jsonString) else {
                    throw PSApiError.mapping(json: jsonString)
                }
                return object
            }
    }
    
    func doRequest<RC: URLRequestConvertible>(requestRouter: RC) -> Promise<String> {
        let request = createRequest(requestRouter)
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
    }
    
    func doRequest<RC: URLRequestConvertible>(requestRouter: RC) -> Promise<Void> {
        let request = createRequest(requestRouter)
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
            .asVoid()
    }
    
    func executeRequest(_ apiRequest: ApiRequest) {
        workQueue.async {
            guard let urlRequest = apiRequest.requestEndPoint.urlRequest else {
                return apiRequest.pendingPromise.resolver.reject(PSApiError.unknown())
            }
            
            guard !self.timeIsSyncing else {
                return self.requestsQueue.append(apiRequest)
            }
            
            self.logger?.log(level: .DEBUG, message: "--> \(urlRequest.url!.absoluteString)")
            self.session
                .request(apiRequest.requestEndPoint)
                .responseData(queue: self.workQueue) { response in
                    self.handleResponse(response, for: apiRequest, with: urlRequest)
                }
        }
    }
    
    func resumeQueue() {
        requestsQueue.forEach(executeRequest)
        requestsQueue.removeAll()
    }
    
    func cancelQueue(error: Error) {
        requestsQueue.forEach { request in
            request.pendingPromise.resolver.reject(error)
        }
        requestsQueue.removeAll()
    }
    
    func handleResponse(
        _ response: AFDataResponse<Data>,
        for apiRequest: ApiRequest,
        with urlRequest: URLRequest,
        expiredTokenHandler: ((ApiRequest) -> Void)? = nil
    ) {
        guard let urlResponse = response.response else {
            return handleMissingUrlResponse(for: apiRequest, with: response.error)
        }
        
        let statusCode = urlResponse.statusCode
        let logMessage = "<-- \(urlRequest.url!.absoluteString) \(statusCode)"
        
        let responseString = String(data: response.data ?? Data(), encoding: .utf8) ?? ""
        if 200 ... 299 ~= statusCode {
            logger?.log(level: .DEBUG, message: logMessage, response: urlResponse)
            return apiRequest.pendingPromise.resolver.fulfill(responseString)
        }
        
        let error = mapError(jsonString: responseString, statusCode: statusCode)
        logger?.log(level: .ERROR, message: logMessage, response: urlResponse, error: error)
        
        if statusCode == 401 && error.isInvalidTimestamp() {
            return syncTimestamp(apiRequest, error)
        }
        
        if
            statusCode == 400,
            error.isTokenExpired(),
            let expiredTokenHandler = expiredTokenHandler
        {
            return expiredTokenHandler(apiRequest)
        }
        
        apiRequest.pendingPromise.resolver.reject(error)
    }
    
    private func mapError(jsonString: String, statusCode: Int) -> PSApiError {
        let error: PSApiError
        
        if 500 ... 600 ~= statusCode {
            error = PSApiError.internalServerError()
        } else {
            error = Mapper<PSApiError>().map(JSONString: jsonString)
                ?? PSApiError.mapping(json: jsonString)
        }
        
        error.statusCode = statusCode
        return error
    }
    
    private func handleMissingUrlResponse(
        for apiRequest: ApiRequest,
        with afError: AFError?
    ) {
        let error: PSApiError
        
        switch afError {
        case .explicitlyCancelled:
            error = .cancelled()
        case .sessionTaskFailed(let e as URLError) where
                e.code == .notConnectedToInternet ||
                e.code == .networkConnectionLost ||
                e.code == .dataNotAllowed:
            error = .noInternet()
        default:
            error = .unknown()
        }
        
        apiRequest.pendingPromise.resolver.reject(error)
    }
    
    private func syncTimestamp(_ apiRequest: ApiRequest, _ error: PSApiError) {
        guard let publicWalletApiClient = publicWalletApiClient else {
            return apiRequest.pendingPromise.resolver.reject(error)
        }
        
        requestsQueue.append(apiRequest)
        guard !timeIsSyncing else {
            return
        }
        
        timeIsSyncing = true
        
        publicWalletApiClient
            .getServerInformation()
            .done(on: workQueue) { serverInformation in
                self.serverTimeSynchronizationProtocol?.serverTimeDifferenceRefreshed(
                    diff: serverInformation.timeDiff
                )
                self.timeIsSyncing = false
                self.resumeQueue()
            }
            .catch(on: workQueue) { error in
                self.timeIsSyncing = false
                self.cancelQueue(error: error)
            }
    }
    
    private func createRequest<RC: URLRequestConvertible>(_ endpoint: RC) -> ApiRequest {
        ApiRequest(
            pendingPromise: Promise<String>.pending(),
            requestEndPoint: endpoint
        )
    }
}
