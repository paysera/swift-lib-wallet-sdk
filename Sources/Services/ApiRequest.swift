import Alamofire
import PromiseKit

class ApiRequest {

    var pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>)
    var requestEndPoint: URLRequestConvertible
    
    required init<T: URLRequestConvertible>(pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>), requestEndPoint: T) {
        
        self.pendingPromise = pendingPromise
        self.requestEndPoint = requestEndPoint
    }
}
