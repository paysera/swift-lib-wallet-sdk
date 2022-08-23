import Alamofire
import PromiseKit

public class PublicWalletApiClient: BaseApiClient {
    public func getServerInformation() -> Promise<PSServerInformation> {
        doRequest(requestRouter: PublicWalletApiRequestRouter.getServerInformation)
    }
    
    public func getServerConfiguration() -> Promise<PSServerConfiguration> {
        doRequest(requestRouter: PublicWalletApiRequestRouter.getServerConfiguration)
    }
}
