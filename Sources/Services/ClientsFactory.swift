import Alamofire


public class ClientsFactory {

    public static func createWalletAsyncClient(sessionManager: SessionManager,
                                               credentials: PSCredentials,
                                               publicWalletApiClient: PublicWalletApiClient,
                                               serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol) -> WalletAsyncClient {
        
        sessionManager.adapter = RequestSigningAdapter(credentials: credentials,
                                                       serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol)
        
        return WalletAsyncClient(sessionManager: sessionManager,
                                 publicWalletApiClient: publicWalletApiClient,
                                 serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol)
    }
    
    
    public static func createOAuthClient(sessionManager: SessionManager,
                                         credentials: PSCredentials,
                                         publicWalletApiClient: PublicWalletApiClient,
                                         serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol) -> OAuthAsyncClient {
  
        sessionManager.adapter = RequestSigningAdapter(credentials: credentials,
                                                       serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol)
        
        return OAuthAsyncClient(sessionManager: sessionManager,
                                publicWalletApiClient: publicWalletApiClient,
                                serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol)
    }
    
    
    public static func createRefreshingWalletAsyncClient(sessionManager: SessionManager,
                                                         credentials: PSCredentials,
                                                         authAsyncClient: OAuthAsyncClient,
                                                         publicWalletApiClient: PublicWalletApiClient,
                                                         serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
                                                         accessTokenRefresherDelegate: AccessTokenRefresherDelegate) -> RefreshingWalletAsyncClient {
        
        sessionManager.adapter = RequestSigningAdapter(credentials: credentials,
                                                       serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol)
        
        return RefreshingWalletAsyncClient(sessionManager: sessionManager,
                                           userCredentials: credentials,
                                           authAsyncClient: authAsyncClient,
                                           publicWalletApiClient: publicWalletApiClient,
                                           serverTimeSynchronizationProtocol: serverTimeSynchronizationProtocol,
                                           accessTokenRefresherDelegate: accessTokenRefresherDelegate)
    }
    
    
    public static func createPublicWalletApiClient(sessionManager: SessionManager) -> PublicWalletApiClient {
        return PublicWalletApiClient(sessionManager: sessionManager)
    }
}
