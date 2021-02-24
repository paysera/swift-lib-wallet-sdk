import Alamofire
import Foundation
import PayseraCommonSDK
import PromiseKit

public protocol AccessTokenRefresherDelegate {
    func activeCredentialsDidUpdate(to activeCredentials: PSCredentials)
    func inactiveCredentialsDidUpdate(to inactiveCredentials: PSCredentials?)
    func refreshTokenIsInvalid(_ error: Error)
    func shouldRefreshTokenBeforeRequest(with activeCredentials: PSCredentials) -> Bool
}

public extension AccessTokenRefresherDelegate {
    func shouldRefreshTokenBeforeRequest(with activeCredentials: PSCredentials) -> Bool {
        false
    }
}

public class RefreshingWalletAsyncClient: WalletAsyncClient {
    
    private var activeCredentials: PSCredentials
    private var inactiveCredentials: PSCredentials?
    private let grantType: PSGrantType
    private let accessTokenRefresherDelegate: AccessTokenRefresherDelegate
    private let authAsyncClient: OAuthAsyncClient
    private var tokenIsRefreshing = false
    
    init(
        session: Session,
        activeCredentials: PSCredentials,
        inactiveCredentials: PSCredentials?,
        grantType: PSGrantType,
        authAsyncClient: OAuthAsyncClient,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        accessTokenRefresherDelegate: AccessTokenRefresherDelegate,
        logger: PSLoggerProtocol? = nil
    ) {
        self.activeCredentials = activeCredentials
        self.inactiveCredentials = inactiveCredentials
        self.grantType = grantType
        self.authAsyncClient = authAsyncClient
        self.accessTokenRefresherDelegate = accessTokenRefresherDelegate
        
        super.init(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }
    
    override func executeRequest(_ apiRequest: ApiRequest) {
        workQueue.async {
            guard let urlRequest = apiRequest.requestEndPoint.urlRequest else {
                return apiRequest.pendingPromise.resolver.reject(PSApiError.unknown())
            }
            
            guard !self.tokenIsRefreshing else {
                return self.requestsQueue.append(apiRequest)
            }
            
            if self.accessTokenRefresherDelegate.shouldRefreshTokenBeforeRequest(with: self.activeCredentials) {
                return self.handleExpiredAccessToken(with: apiRequest)
            }
            
            self.logger?.log(
                level: .DEBUG,
                message: "--> \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString)",
                request: urlRequest
            )
            
            self.session
                .request(apiRequest.requestEndPoint)
                .responseData(queue: self.workQueue) { response in
                    self.handleResponse(response, for: apiRequest, with: urlRequest)
                }
        }
    }
    
    public func refreshToken(
        grantType: PSGrantType = .refreshToken,
        code: String,
        extensionScopes: [String]
    ) -> Promise<PSCredentials> {
        Promise { seal in
            workQueue.async {
                self.refreshToken(grantType: grantType, code: code, scopes: extensionScopes)
                    .done(on: self.workQueue, seal.fulfill)
                    .catch(on: self.workQueue, seal.reject)
            }
        }
    }
    
    private func handleExpiredAccessToken(with apiRequest: ApiRequest) {
        guard !hasRecentlyRefreshed() else {
            return executeRequest(apiRequest)
        }
        
        requestsQueue.append(apiRequest)
        
        guard !tokenIsRefreshing else {
            return
        }
        
        tokenIsRefreshing = true
        refreshToken(grantType: grantType)
    }
    
    private func handleResponse(
        _ response: AFDataResponse<Data>,
        for apiRequest: ApiRequest,
        with urlRequest: URLRequest
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
        
        if statusCode == 400 && error.isTokenExpired() {
            return handleExpiredAccessToken(with: apiRequest)
        }
        
        apiRequest.pendingPromise.resolver.reject(error)
    }
    
    @discardableResult
    private func refreshToken(
        grantType: PSGrantType,
        code: String? = nil,
        scopes: [String]? = nil
    ) -> Promise<PSCredentials> {
        Promise { seal in
            let refreshPromise = createRefreshPromise(
                grantType: grantType,
                code: code,
                scopes: scopes
            )
            
            refreshPromise
                .done(on: workQueue) { credentials in
                    self.handleSuccessfullTokenRefresh(with: credentials)
                    seal.fulfill(credentials)
                }
                .catch(on: workQueue) { error in
                    self.handleRefreshTokenError(error)
                    seal.reject(error)
                }
        }
    }
    
    private func createRefreshPromise(
        grantType: PSGrantType,
        code: String?,
        scopes: [String]?
    ) -> Promise<PSCredentials> {
        switch grantType {
        case .refreshToken:
            if let activeRefreshToken = activeCredentials.refreshToken {
                return authAsyncClient.refreshToken(
                    activeRefreshToken,
                    grantType: grantType,
                    code: code,
                    scopes: scopes
                )
            } else {
                return .init(error: PSApiError.unknown())
            }
        case .refreshTokenWithActivation:
            if let inactiveAccessToken = inactiveCredentials?.accessToken {
                return authAsyncClient.activate(accessToken: inactiveAccessToken)
            } else if let activeRefreshToken = activeCredentials.refreshToken {
                return authAsyncClient
                    .refreshToken(activeRefreshToken, grantType: grantType, code: code, scopes: scopes)
                    .get(on: workQueue) { self.updateInactiveCredentials(to: $0) }
                    .compactMap(on: workQueue) { $0.accessToken }
                    .then(on: workQueue) { inactiveAccessToken in
                        self.authAsyncClient.activate(accessToken: inactiveAccessToken)
                    }
            } else {
                return .init(error: PSApiError.unknown())
            }
        }
    }
    
    private func handleSuccessfullTokenRefresh(with credentials: PSCredentials) {
        updateActiveCredentials(using: credentials)
        tokenIsRefreshing = false
        resumeQueue()
    }
    
    private func handleRefreshTokenError(_ error: Error) {
        tokenIsRefreshing = false
        
        if let walletApiError = error as? PSApiError, walletApiError.isRefreshTokenExpired() {
            accessTokenRefresherDelegate.refreshTokenIsInvalid(error)
        } else if let statusCode = (error as? PSApiError)?.statusCode, 400...499 ~= statusCode {
            updateInactiveCredentials(to: nil)
        }
        
        cancelQueue(error: error)
    }
    
    private func hasRecentlyRefreshed() -> Bool {
        guard
            let validUntil = activeCredentials.validUntil,
            let expiresIn = activeCredentials.expiresIn
        else { return false }
        
        return expiresIn - validUntil.timeIntervalSinceNow <= 15
    }
    
    private func updateActiveCredentials(using refreshedCredentials: PSCredentials) {
        activeCredentials.accessToken = refreshedCredentials.accessToken
        activeCredentials.macKey = refreshedCredentials.macKey
        activeCredentials.refreshToken = refreshedCredentials.refreshToken
        activeCredentials.validUntil = refreshedCredentials.validUntil
        activeCredentials.expiresIn = refreshedCredentials.expiresIn
        accessTokenRefresherDelegate.activeCredentialsDidUpdate(to: refreshedCredentials)
        updateInactiveCredentials(to: nil)
    }
    
    private func updateInactiveCredentials(to inactiveCredentials: PSCredentials?) {
        self.inactiveCredentials = inactiveCredentials
        accessTokenRefresherDelegate.inactiveCredentialsDidUpdate(to: inactiveCredentials)
    }
}
