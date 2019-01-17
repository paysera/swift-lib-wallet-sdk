import Alamofire

public class ClientsFactory {
    public static func createWalletAsyncClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol
    ) -> WalletAsyncClient {
        let sessionManager = self.createSessionManager()
        sessionManager.adapter = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol
        )
        
        return WalletAsyncClient(
            sessionManager: sessionManager,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol
        )
    }
    
    public static func createOAuthClient(
        credentials: PSCredentials,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol
    ) -> OAuthAsyncClient {
        let sessionManager = self.createSessionManager()
        sessionManager.adapter = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol
        )
        
        return OAuthAsyncClient(
            sessionManager: sessionManager,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol
        )
    }
    
    public static func createRefreshingWalletAsyncClient(
        credentials: PSCredentials,
        authAsyncClient: OAuthAsyncClient,
        publicWalletApiClient: PublicWalletApiClient,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        accessTokenRefresherDelegate: AccessTokenRefresherDelegate
    ) -> RefreshingWalletAsyncClient {
        let sessionManager = self.createSessionManager()
        sessionManager.adapter = RequestSigningAdapter(
            credentials: credentials,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol
        )
        
        return RefreshingWalletAsyncClient(
            sessionManager: sessionManager,
            userCredentials: credentials,
            authAsyncClient: authAsyncClient,
            publicWalletApiClient: publicWalletApiClient,
            serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
            accessTokenRefresherDelegate: accessTokenRefresherDelegate
        )
    }
    
    public static func createPublicWalletApiClient() -> PublicWalletApiClient {
        return PublicWalletApiClient(sessionManager: self.createSessionManager())
    }
    
    private static func createSessionManager() -> SessionManager {
        let serverTrustPolicy = ServerTrustPolicy.pinPublicKeys(
            publicKeys: [
                self.getSecKey(name: "main-certificate")!,
                self.getSecKey(name: "backup-certificate")!,
            ],
            validateCertificateChain: true,
            validateHost: true
        )
        let policies = ["wallet-api.paysera.com": serverTrustPolicy]
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: policies)
        
        return SessionManager(serverTrustPolicyManager: serverTrustPolicyManager)
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
