import Alamofire
import PayseraCommonSDK

public class ClientsFactory {
    public static func createWalletAsyncClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> WalletAsyncClient {
        let interceptor = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return WalletAsyncClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }
    
    public static func createOAuthClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> OAuthAsyncClient {
        let interceptor = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return OAuthAsyncClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }
    
    public static func createRefreshingWalletAsyncClient(
        activeCredentials: PSCredentials,
        inactiveCredentials: PSCredentials?,
        grantType: PSGrantType = .refreshToken,
        authAsyncClient: OAuthAsyncClient,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        accessTokenRefresherDelegate: AccessTokenRefresherDelegate,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> RefreshingWalletAsyncClient {
        let interceptor = RequestSigningAdapter(
            credentials: activeCredentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return RefreshingWalletAsyncClient(
            session: session,
            activeCredentials: activeCredentials,
            inactiveCredentials: inactiveCredentials,
            grantType: grantType,
            authAsyncClient: authAsyncClient,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            accessTokenRefresherDelegate: accessTokenRefresherDelegate,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            logger: logger
        )
    }
    
    public static func createPublicWalletApiClient(
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> PublicWalletApiClient {
        let session = createSession()
        return PublicWalletApiClient(
            session: session,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            logger: logger
        )
    }
    
    public static func createPartnerOAuthApiClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> PartnerOAuthWalletAsyncClient {
        let interceptor = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return PartnerOAuthWalletAsyncClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }

    private static func createSession(with interceptor: RequestInterceptor? = nil) -> Session {
        Session(interceptor: interceptor)
    }
}
