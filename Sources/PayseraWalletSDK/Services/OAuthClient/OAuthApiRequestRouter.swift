import Alamofire
import Foundation

enum OAuthApiRequestRouter {

    // MARK: - POST
    case login(PSUserLoginRequest)
    case refreshToken(PSRefreshTokenRequest)
    
    // MARK: - PUT
    case activate(accessToken: String)
    
    // MARK: - Delete
    case revoke(accessToken: String)

    private static let baseURL = URL(string: "https://wallet-api.paysera.com")!
    
    private var method: HTTPMethod {
        switch self {
        case .login,
             .refreshToken:
            return .post
            
        case .activate:
            return .put
            
        case .revoke:
            return .delete
        }
    }
    
    private var path: String {
        switch self {
        case .login,
             .refreshToken,
             .revoke:
            return "oauth/v1/token"
            
        case .activate(let accessToken):
            return "oauth/v1/tokens/\(accessToken)/activate"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .refreshToken(let params):
            return params.toJSON()
            
        case .login(let userLoginData):
            return userLoginData.toJSON()
            
        case .revoke(let accessToken):
            return ["access_token": accessToken]
            
        default:
            return nil
        }
    }
}

extension OAuthApiRequestRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        switch self {
        case .refreshToken,
             .revoke,
             .login,
             .activate:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
