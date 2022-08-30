import Alamofire
import PromiseKit

public class PartnerTokenApiClient: BaseApiClient {
    public func getPartnerTokens(
        payload: PSPartnerOAuthRequest
    ) -> Promise<PSPartnerTokensOAuthResponse> {
        doRequest(requestRouter: PartnerTokenApiRequestRouter.getPartnerTokens(payload))
    }
}
