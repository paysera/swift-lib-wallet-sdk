import Alamofire
import PromiseKit

public class PartnerOAuthApiClient: BaseApiClient {
    public func createOAuthRequest(
        payload: PSPartnerOAuthRequest
    ) -> Promise<PSCreatePartnerOAuthResponse> {
        doRequest(
            requestRouter: PartnerOAuthApiRequestRouter.createOAuthRequest(payload: payload)
        )
    }
    
    public func approveOAuthRequest(key: String) -> Promise<PSPartnerTokensOAuthResponse> {
        doRequest(requestRouter: PartnerOAuthApiRequestRouter.approveOAuthRequest(key: key))
    }
}
