import Alamofire
import PromiseKit

class ApiRequest {

    var pendingPromise: (promise: Promise<String>, resolver: Resolver<String>)
    var requestEndPoint: URLRequestConvertible
    
    required init<T: URLRequestConvertible>(pendingPromise: (promise: Promise<String>, resolver: Resolver<String>), requestEndPoint: T) {
        
        self.pendingPromise = pendingPromise
        self.requestEndPoint = requestEndPoint
    }
}
