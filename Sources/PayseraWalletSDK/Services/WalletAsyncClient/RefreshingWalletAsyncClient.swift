import Alamofire
import Foundation
import PayseraCommonSDK
import PromiseKit

public protocol AccessTokenRefresherDelegate {
    func activeCredentialsDidUpdate(to activeCredentials: PSCredentials)
    func inactiveCredentialsDidUpdate(to inactiveCredentials: PSCredentials?)
    func refreshTokenIsInvalid(_ error: Error, refreshToken: String?)
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
    private var tokenRefreshAttempt = 0
    
    init(
        session: Session,
        activeCredentials: PSCredentials,
        inactiveCredentials: PSCredentials?,
        grantType: PSGrantType,
        authAsyncClient: OAuthAsyncClient,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        accessTokenRefresherDelegate: AccessTokenRefresherDelegate,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
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
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }
    
    public override func cancelAllOperations() {
        super.cancelAllOperations()
        tokenRefreshAttempt = 0
    }
    
    override func executeRequest(_ apiRequest: ApiRequest) {
        workQueue.async {
            guard let urlRequest = apiRequest.requestEndPoint.urlRequest else {
                return apiRequest.pendingPromise.resolver.reject(PSApiError.unknown())
            }
            
            guard !self.tokenIsRefreshing && !self.hasReachedRetryLimit else {
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
                    self.handleResponse(
                        response,
                        for: apiRequest,
                        with: urlRequest,
                        expiredTokenHandler: self.handleExpiredAccessToken
                    )
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
    
    @discardableResult
    private func refreshToken(
        grantType: PSGrantType,
        code: String? = nil,
        scopes: [String]? = nil
    ) -> Promise<PSCredentials> {
        Promise { seal in
            let activeRefreshToken = activeCredentials.refreshToken
            let refreshPromise = createRefreshPromise(
                activeRefreshToken: activeRefreshToken,
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
                    self.handleRefreshTokenError(error, refreshToken: activeRefreshToken)
                    seal.reject(error)
                }
        }
    }
    
    private func createRefreshPromise(
        activeRefreshToken: String?,
        grantType: PSGrantType,
        code: String?,
        scopes: [String]?
    ) -> Promise<PSCredentials> {
        switch grantType {
        case .refreshToken:
            if let activeRefreshToken = activeRefreshToken {
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
            } else if let activeRefreshToken = activeRefreshToken {
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
        tokenRefreshAttempt = 0
        updateActiveCredentials(using: credentials)
        tokenIsRefreshing = false
        resumeQueue()
    }
    
    private func handleRefreshTokenError(_ error: Error, refreshToken: String?) {
        if let walletApiError = error as? PSApiError, walletApiError.isRefreshTokenExpired() {
            accessTokenRefresherDelegate.refreshTokenIsInvalid(error, refreshToken: refreshToken)
            tokenIsRefreshing = false
        } else if let statusCode = (error as? PSApiError)?.statusCode, 400...499 ~= statusCode {
            updateInactiveCredentials(to: nil)
            scheduleEndOfTokenRefresh()
        } else if let statusCode = (error as? PSApiError)?.statusCode, 500...599 ~= statusCode {
            scheduleEndOfTokenRefresh()
        }
        
        cancelQueue(error: error)
    }
    
    private func scheduleEndOfTokenRefresh() {
        if tokenRefreshAttempt + 1 <= 4 {
            tokenRefreshAttempt += 1
        }
        
        let baseDelay = pow(Double(tokenRefreshAttempt), 3)
        let randomDelay = Double.random(in: 0..<ceil(baseDelay / 2))
        let finalDelay = baseDelay + randomDelay
        
        workQueue.asyncAfter(deadline: .now() + finalDelay) {
            self.tokenIsRefreshing = false
        }
    }
    
    private func hasRecentlyRefreshed() -> Bool {
        guard
            let validUntil = activeCredentials.validUntil,
            let expiresIn = activeCredentials.expiresIn
        else { return false }
        
        return abs(expiresIn - validUntil.timeIntervalSinceNow) < 15
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
