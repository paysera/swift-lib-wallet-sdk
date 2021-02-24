import Alamofire
import Foundation

public enum PublicApiRequestRouter: URLRequestConvertible {
    
    case getServerInformation
    case getServerConfiguration
    
    static let baseURL = URL(string: "https://wallet-api.paysera.com/rest/v1")!
    
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
            return "server"
        case .getServerConfiguration:
            return "configuration"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        switch self {
        case .getServerConfiguration,
             .getServerInformation:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
    
}
