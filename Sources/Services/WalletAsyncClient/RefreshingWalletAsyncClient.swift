import Alamofire
import PromiseKit
import PayseraCommonSDK

public protocol AccessTokenRefresherDelegate {
    func activeCredentialsDidUpdate(to activeCredentials: PSCredentials)
    func inactiveCredentialsDidUpdate(to inactiveCredentials: PSCredentials?)
    func refreshTokenIsInvalid(_ error: Error)
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
    
    override func makeRequest(apiRequest: ApiRequest) {
        guard let urlRequest = apiRequest.requestEndPoint.urlRequest else { return }
        
        lockQueue.async {
            guard !self.tokenIsRefreshing else {
                self.requestsQueue.append(apiRequest)
                return
            }
            self.logger?.log(
                level: .DEBUG,
                message: "--> \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString)",
                request: urlRequest
            )
            
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
                    if statusCode == 400 && error.isTokenExpired() {
                        self.handleExpiredAccessToken(apiRequest, error)
                        return
                    }
                    
                    apiRequest.pendingPromise.resolver.reject(error)
            }
        }
    }
    
    public func refreshToken(grantType: PSGrantType = .refreshToken, code: String, extensionScopes: [String]) -> Promise<PSCredentials> {
        return refreshToken(grantType: grantType, code: code, scopes: extensionScopes)
    }
    
    func handleExpiredAccessToken(_ apiRequest: ApiRequest, _ error: PSApiError) {
        lockQueue.async {
            guard !self.hasRecentlyRefreshed() else {
                self.makeRequest(apiRequest: apiRequest)
                return
            }
            
            self.requestsQueue.append(apiRequest)
            
            guard !self.tokenIsRefreshing else {
                return
            }
            
            self.tokenIsRefreshing = true
            self.refreshToken(grantType: self.grantType)
        }
    }
    
    @discardableResult
    private func refreshToken(grantType: PSGrantType, code: String? = nil, scopes: [String]? = nil) -> Promise<PSCredentials> {
        return Promise<PSCredentials> { seal in
            self.lockQueue.async {
                let refreshPromise: Promise<PSCredentials>
                
                switch grantType {
                case .refreshToken:
                    if let activeRefreshToken = self.activeCredentials.refreshToken {
                        refreshPromise = self.authAsyncClient.refreshToken(activeRefreshToken, grantType: grantType, code: code, scopes: scopes)
                    } else {
                        refreshPromise = .init(error: PSApiError.unknown())
                    }
                case .refreshTokenWithActivation:
                    if let inactiveAccessToken = self.inactiveCredentials?.accessToken {
                        refreshPromise = self.authAsyncClient.activate(accessToken: inactiveAccessToken)
                    } else if let activeRefreshToken = self.activeCredentials.refreshToken {
                        refreshPromise = self.authAsyncClient.refreshToken(activeRefreshToken, grantType: grantType, code: code, scopes: scopes)
                            .get(on: self.lockQueue) { self.updateInactiveCredentials(using: $0) }
                            .compactMap { $0.accessToken }
                            .then { inactiveAccessToken in self.authAsyncClient.activate(accessToken: inactiveAccessToken) }
                    } else {
                        refreshPromise = .init(error: PSApiError.unknown())
                    }
                }
                
                refreshPromise
                    .done(on: self.lockQueue) { credentials in
                        self.handleSuccessfullTokenRefresh(with: credentials)
                        seal.fulfill(credentials)
                    }
                    .catch(on: self.lockQueue) { error in
                        self.handleRefreshTokenError(error)
                        seal.reject(error)
                    }
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
        }
        cancelQueue(error: error)
    }
    
    private func hasRecentlyRefreshed() -> Bool {
        guard
            let validUntil = activeCredentials.validUntil,
            let expiresIn = activeCredentials.expiresIn
        else { return false }
        return abs(expiresIn - validUntil.timeIntervalSinceNow) < 15
    }
    
    private func updateActiveCredentials(using refreshedCredentials: PSCredentials) {
        inactiveCredentials = nil
        activeCredentials.accessToken = refreshedCredentials.accessToken
        activeCredentials.macKey = refreshedCredentials.macKey
        activeCredentials.refreshToken = refreshedCredentials.refreshToken
        activeCredentials.validUntil = refreshedCredentials.validUntil
        activeCredentials.expiresIn = refreshedCredentials.expiresIn
        accessTokenRefresherDelegate.inactiveCredentialsDidUpdate(to: nil)
        accessTokenRefresherDelegate.activeCredentialsDidUpdate(to: refreshedCredentials)
    }
    
    private func updateInactiveCredentials(using inactiveCredentials: PSCredentials) {
        self.inactiveCredentials = inactiveCredentials
        accessTokenRefresherDelegate.inactiveCredentialsDidUpdate(to: inactiveCredentials)
    }
}
