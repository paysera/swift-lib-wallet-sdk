import Alamofire
import PromiseKit

public class PublicWalletApiClient: BaseAsyncClient {

    public func getServerInformation() -> Promise<PSServerInformation> {
        doRequest(requestRouter: PublicApiRequestRouter.getServerInformation)
    }
    
    public func getServerConfiguration() -> Promise<PSServerConfiguration> {
        doRequest(requestRouter: PublicApiRequestRouter.getServerConfiguration)
    }
}
