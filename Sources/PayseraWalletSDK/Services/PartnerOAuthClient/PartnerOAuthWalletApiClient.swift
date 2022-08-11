import Alamofire
import PromiseKit

public class PartnerOAuthWalletApiClient: BaseAsyncClient {
    public func createOAuthRequest(
        payload: PSPartnerTokensRequest
    ) -> Promise<PSCreatePartnerOAuthResponse> {
        doRequest(
            requestRouter: PartnerOAuthApiRequestRouter.createOAuthRequest(payload: payload)
        )
    }
    
    public func approveOAuthRequest(key: String) -> Promise<PSPartnerTokensResponse> {
        doRequest(requestRouter: PartnerOAuthApiRequestRouter.approveOAuthRequest(key: key))
    }
}
