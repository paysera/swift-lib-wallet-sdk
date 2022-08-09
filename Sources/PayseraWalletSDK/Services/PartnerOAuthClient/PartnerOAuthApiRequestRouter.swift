import Alamofire
import Foundation

enum PartnerOAuthApiRequestRouter {
    // POST
    case createOAuthRequest
    
    // PUT
    case approveOAuthRequest(key: String)
    
    private static let baseURL = URL(string: "https://wallet.paysera.com/partner-oauth/v1")!
    
    private var method: HTTPMethod {
        switch self {
        case .createOAuthRequest:
            return .post
        case .approveOAuthRequest:
            return .put
        }
    }
    
    private var path: String {
        switch self {
        case .createOAuthRequest:
            return "partner-oauth-requests"
        case .approveOAuthRequest(let key):
            return "partner-oauth-requests/\(key)/approve"
    }
}

// MARK: - URLRequestConvertible
    
extension PartnerOAuthApiRequestRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        switch self {
        case .createOAuthRequest,
             .approveOAuthRequest:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
