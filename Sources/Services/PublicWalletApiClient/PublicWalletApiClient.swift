import Alamofire
import PromiseKit

public class PublicWalletApiClient: BaseAsyncClient {

    public func getServerInformation() -> Promise<PSServerInformation> {
        return doRequest(requestRouter: PublicApiRequestRouter.getServerInformation())
    }
    
    public func getServerConfiguration() -> Promise<PSServerConfiguration> {
        return doRequest(requestRouter: PublicApiRequestRouter.getServerConfiguration())
    }
}
