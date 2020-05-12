import Alamofire
import PayseraCommonSDK

public class ClientsFactory {
    public static func createWalletAsyncClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        logger: PSLoggerProtocol? = nil
    ) -> WalletAsyncClient {
        let session = self.createSession(interceptor: RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        ))
        
        return WalletAsyncClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        )
    }
    
    public static func createOAuthClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        logger: PSLoggerProtocol? = nil
    ) -> OAuthAsyncClient {
        let session = self.createSession(interceptor: RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        ))
        
        return OAuthAsyncClient(
            session: session,
            publicWalletApiClient: publicWalletApiClient,
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
        logger: PSLoggerProtocol? = nil
    ) -> RefreshingWalletAsyncClient {
        let session = self.createSession(interceptor: RequestSigningAdapter(
            credentials: activeCredentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            logger: logger
        ))
        
        return RefreshingWalletAsyncClient(
            session: session,
            activeCredentials: activeCredentials,
            inactiveCredentials: inactiveCredentials,
            grantType: grantType,
            authAsyncClient: authAsyncClient,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            accessTokenRefresherDelegate: accessTokenRefresherDelegate,
            logger: logger
        )
    }
    
    public static func createPublicWalletApiClient(logger: PSLoggerProtocol? = nil) -> PublicWalletApiClient {
        return PublicWalletApiClient(session: self.createSession(), logger: logger)
    }
    
    private static func createSession(interceptor: RequestInterceptor? = nil) -> Session {
        let evaluator = PublicKeysTrustEvaluator(keys: [
            self.getSecKey(name: "main-certificate")!,
            self.getSecKey(name: "backup-certificate")!,
        ], performDefaultValidation: true, validateHost: true)
        
        let serverTrustManager = ServerTrustManager(evaluators: [
            "wallet-api.paysera.com": evaluator
        ])
        
        return Session(interceptor: interceptor, serverTrustManager: serverTrustManager)
    }
    
    private static func getSecKey(name: String) -> SecKey? {
        let certificateData = NSData(contentsOf: Bundle(for: ClientsFactory.self).url(forResource: name, withExtension: "der")!)
        let certificate = SecCertificateCreateWithData(nil, certificateData!)
        
        var trust: SecTrust?
        
        let policy = SecPolicyCreateBasicX509()
        let status = SecTrustCreateWithCertificates(certificate!, policy, &trust)
        
        var key: SecKey?
        if status == errSecSuccess {
            key = SecTrustCopyPublicKey(trust!)!;
        }
        return key
    }
}
