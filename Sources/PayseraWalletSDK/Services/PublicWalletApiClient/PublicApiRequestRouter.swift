import Foundation
import Alamofire

public enum PublicApiRequestRouter: URLRequestConvertible {
    
    case getServerInformation
    case getServerConfiguration
    
    static var baseURLString = "https://wallet-api.paysera.com/rest/v1"
    
    private var method: HTTPMethod {
        switch self {
            
        case .getServerInformation:
            return .get
        case .getServerConfiguration:
            return .get
        }
    }
    
    private var path: String {
        switch self {
            
        case .getServerInformation:
            return "/server"
        case .getServerConfiguration:
            return "/configuration"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try! PublicApiRequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
    
}
