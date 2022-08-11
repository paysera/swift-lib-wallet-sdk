import Alamofire
import PromiseKit

public class PartnerOAuthWalletApiClient: BaseAsyncClient {
    public func createOAuthRequest(
        payload: PSPartnerTokensOAuthRequest
    ) -> Promise<PSCreatePartnerOAuthResponse> {
        doRequest(
            requestRouter: PartnerOAuthApiRequestRouter.createOAuthRequest(payload: payload)
        )
    }
    
    public func approveOAuthRequest(key: String) -> Promise<PSPartnerTokensOAuthResponse> {
        doRequest(requestRouter: PartnerOAuthApiRequestRouter.approveOAuthRequest(key: key))
    }
}
