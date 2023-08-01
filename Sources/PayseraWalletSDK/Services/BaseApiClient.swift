import Alamofire
import Foundation
import ObjectMapper
import PayseraCommonSDK
import PromiseKit

public class BaseApiClient {
    var requestsQueue = [ApiRequest]()
    var timeIsSyncing = false
    var hasReachedRetryLimit = false
    let session: Session
    let logger: PSLoggerProtocol?
    let workQueue = DispatchQueue(label: String(describing: BaseApiClient.self))
    private let publicWalletApiClient: PublicWalletApiClient?
    private let rateLimitUnlockerDelegate: RateLimitUnlockerDelegate?
    private let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol?
    
    init(
        session: Session,
        publicWalletApiClient: PublicWalletApiClient? = nil,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol? = nil,
        logger: PSLoggerProtocol?
    ) {
        self.session = session
        self.publicWalletApiClient = publicWalletApiClient
        self.rateLimitUnlockerDelegate = rateLimitUnlockerDelegate
        self.serverTimeSynchronizationProtocol = serverTimeSynchronizationProtocol
        self.logger = logger
    }
    
    public func cancelAllOperations() {
        session.cancelAllRequests()
        cancelQueue(error: PSApiError.cancelled())
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
            
            guard !self.timeIsSyncing && !self.hasReachedRetryLimit else {
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
        
        switch statusCode {
        case 200...299:
            logger?.log(level: .DEBUG, message: logMessage, response: urlResponse)
            
            handleSuccessfulResponse(for: apiRequest, with: responseString)
        default:
            let correlationID = urlResponse.headers
                .first(where: { $0.name == "paysera-correlation-id" })?
                .value
            let error = mapError(
                jsonString: responseString,
                statusCode: statusCode,
                correlationID: correlationID
            )
            
            logger?.log(level: .ERROR, message: logMessage, response: urlResponse, error: error)
            
            handleErrorResponse(
                apiRequest: apiRequest,
                urlResponse: urlResponse,
                error: error,
                expiredTokenHandler: expiredTokenHandler
            )
        }
    }
    
    private func handleSuccessfulResponse(for apiRequest: ApiRequest, with response: String) {
        apiRequest.pendingPromise.resolver.fulfill(response)
    }
    
    private func handleErrorResponse(
        apiRequest: ApiRequest,
        urlResponse: HTTPURLResponse,
        error: PSApiError,
        expiredTokenHandler: ((ApiRequest) -> Void)?
    ) {
        if
            urlResponse.statusCode == 401,
            error.isInvalidTimestamp()
        {
            syncTimestamp(apiRequest, error)
        } else if
            urlResponse.statusCode == 400,
            error.isTokenExpired(),
            let expiredTokenHandler
        {
            expiredTokenHandler(apiRequest)
        } else if
            urlResponse.statusCode == 429,
            rateLimitUnlockerDelegate != nil,
            let siteKey = urlResponse.value(forHTTPHeaderField: ReCAPTCHAHeader.siteKey.rawValue),
            let unlockURLString = urlResponse.value(forHTTPHeaderField: ReCAPTCHAHeader.unlockURL.rawValue),
            let unlockURL = URL(string: unlockURLString)
        {
            handleRetryLimitReached(apiRequest: apiRequest, unlockURL: unlockURL, siteKey: siteKey)
        } else {
            apiRequest.pendingPromise.resolver.reject(error)
        }
    }
    
    private func handleRetryLimitReached(
        apiRequest: ApiRequest,
        unlockURL: URL,
        siteKey: String
    ) {
        hasReachedRetryLimit = true
        rateLimitUnlockerDelegate?.unlock(
            url: unlockURL,
            siteKey: siteKey,
            lastRequestBody: apiRequest.requestEndPoint.urlRequest?.httpBody
        ) { [weak self] didUnlock in
            guard let self = self else { return }

            if didUnlock {
                apiRequest.pendingPromise.resolver.reject(PSApiError.silenced())
            } else {
                apiRequest.pendingPromise.resolver.reject(PSApiError.cancelled())
            }
            
            self.hasReachedRetryLimit = false
        }
    }
    
    private func mapError(
        jsonString: String,
        statusCode: Int,
        correlationID: String?
    ) -> PSApiError {
        let error: PSApiError
        
        if 500 ... 600 ~= statusCode {
            error = PSApiError.internalServerError(with: correlationID)
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
