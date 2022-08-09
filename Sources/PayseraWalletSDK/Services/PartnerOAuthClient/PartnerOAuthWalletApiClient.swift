import Alamofire
import PromiseKit

public class PartnerOAuthWalletApiClient: BaseAsyncClient {
    public func createOAuthRequest() -> Promise<Void> {
        doRequest(requestRouter: PartnerOAuthApiRequestRouter.createOAuthRequest)
    }
    
    public func approveOAuthRequest(key: String) -> Promise<Void> {
        doRequest(requestRouter: PartnerOAuthApiRequestRouter.approveOAuthRequest(key: key))
    }
}
