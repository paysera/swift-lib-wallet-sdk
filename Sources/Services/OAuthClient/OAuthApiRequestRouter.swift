import Alamofire

enum OAuthApiRequestRouter: URLRequestConvertible {

    case login(PSUserLoginRequest)
    case refreshToken(PSRefreshTokenRequest)
    case revoke(accessToken: String)

    static var baseURLString = "https://wallet-api.paysera.com"
    
    
    private var method: HTTPMethod {
        
        switch self {
            
        case .login(_),
             .refreshToken(_):
            return .post
            
        case .revoke(_):
            return .delete
        }
    }
    
    private var path: String {
        
        switch self {
            
        case .login(_), .refreshToken(_), .revoke(_):
            return "/oauth/v1/token"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .refreshToken(let params):
            return params.toJSON()
            
        case .login(let userLoginData):
            return userLoginData.toJSON()
            
        case .revoke(let accessToken):
            return["access_token": accessToken]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try! OAuthApiRequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .refreshToken(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .revoke(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .login(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
    
}
