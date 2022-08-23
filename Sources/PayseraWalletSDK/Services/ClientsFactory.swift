import Alamofire
import PayseraCommonSDK

public class ClientsFactory {
    public static func createWalletApiClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> WalletApiClient {
        let interceptor = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return WalletApiClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }
    
    public static func createRefreshingWalletApiClient(
        activeCredentials: PSCredentials,
        inactiveCredentials: PSCredentials?,
        grantType: PSGrantType = .refreshToken,
        authApiClient: OAuthApiClient,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        accessTokenRefresherDelegate: AccessTokenRefresherDelegate,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> RefreshingWalletApiClient {
        let interceptor = RequestSigningAdapter(
            credentials: activeCredentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return RefreshingWalletApiClient(
            session: session,
            activeCredentials: activeCredentials,
            inactiveCredentials: inactiveCredentials,
            grantType: grantType,
            authApiClient: authApiClient,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            accessTokenRefresherDelegate: accessTokenRefresherDelegate,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            logger: logger
        )
    }
    
    public static func createOAuthApiClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> OAuthApiClient {
        let interceptor = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return OAuthApiClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
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
    
    public static func createPartnerTokenApiClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> PartnerTokenApiClient {
        let interceptor = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return PartnerTokenApiClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            rateLimitUnlockerDelegate: rateLimitUnlockerDelegate,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }

    public static func createPartnerOAuthApiClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        rateLimitUnlockerDelegate: RateLimitUnlockerDelegate? = nil,
        logger: PSLoggerProtocol? = nil
    ) -> PartnerOAuthApiClient {
        let interceptor = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
        let session = createSession(with: interceptor)
        
        return PartnerOAuthApiClient(
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
