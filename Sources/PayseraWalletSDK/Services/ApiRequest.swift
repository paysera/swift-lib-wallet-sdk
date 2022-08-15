import Alamofire
import AlamofireNetworkActivityLogger
import PromiseKit

class ApiRequest {
    let pendingPromise: (promise: Promise<String>, resolver: Resolver<String>)
    let requestEndPoint: URLRequestConvertible
    
    required init<T: URLRequestConvertible>(
        pendingPromise: (promise: Promise<String>, resolver: Resolver<String>),
        requestEndPoint: T
    ) {
        self.pendingPromise = pendingPromise
        self.requestEndPoint = requestEndPoint
        
//        NetworkActivityLogger.shared.startLogging()
//        NetworkActivityLogger.shared.level = .debug
    }
}
