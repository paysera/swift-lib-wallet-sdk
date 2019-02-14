import Alamofire

public enum WalletApiRequestRouter: URLRequestConvertible {

    case get(path: String, parameters: [String: Any]?)
    case post(path: String, parameters: [String: Any]?)
    case put(path: String, parameters: [String: Any]?)
    case putWithData(path: String, data: Data, contentType: String)
    case delete(path: String, parameters: [String: Any]?)
    
    
    // MARK: - GET
    case getLocations(PSGetLocationsRequest)
    case getLocationCategories(locale: String)
    case getCurrentUser()
    case getUser(PSGetUserRequest)
    case getWallet(id: Int)
    case getUserWallets(inactiveIncluded: String)
    case getSpot(id: Int)
    case getTransfer(id: Int)
    
    
    // MARK: - POST
    case registerClient(PSCreateClientRequest)
    case registerUser(PSUserRegistrationRequest)
    case resetPassword(PSPasswordResetRequest)
    case sendPhoneVerificationCode(userId: Int, phone: String, scopes: [String])
    case changePassword(userId: Int, PSPasswordChangeRequest)
    
    // MARK: - Put
    case verifyPhone(userId: Int, code: String)
    case checkIn(spotId: Int, fields: [String])
    
    // MARK: - Variables
    static var baseURLString = "https://wallet-api.paysera.com/rest/v1"

    private var method: HTTPMethod {
        switch self {
        case .post(_),
             .registerClient(_),
             .registerUser(_),
             .resetPassword(_),
             .sendPhoneVerificationCode(_):
            return .post
            
        case .get(_),
             .getLocationCategories(_),
             .getCurrentUser(),
             .getUser(_),
             .getLocations(_),
             .getWallet(_),
             .getUserWallets(_),
             .getSpot(_),
             .getTransfer(_):
            return .get
            
        case .put(_),
             .putWithData(_, _, _),
             .verifyPhone(_, _),
             .changePassword(_),
             .checkIn(_, _):
            return .put
            
        case .delete(_, _):
            return .delete
        }

    }
    
    private var path: String {
        switch self {
        case .getCurrentUser():
            return "/user/me"
            
        case .verifyPhone(let userId, _):
            return "/user/\(userId)/phone/confirm"
            
        case .getUser(_),
             .registerUser(_):
            return "/user"
            
        case .getSpot(let id):
            return "spot/\(id)"
            
        case .getTransfer(let id):
            return "transfers/\(id)"
            
        case .resetPassword(_):
            return "/user/password/reset"
            
        case .getWallet(let id):
            return "/wallet/\(id)"
            
        case .getUserWallets(_):
            return "user/me/wallets"
            
        case .sendPhoneVerificationCode(let userId, _, _):
            return "/user/\(userId)/phone"
            
        case .changePassword(let userId, _):
            return "/user/\(userId)/password"
            
        case .registerClient(_):
            return "/client"
            
        case .getLocations(_):
            return "/locations"
            
        case .getLocationCategories:
            return "/locations/pay-categories"
            
        case .get(let path, _),
             .post(let path, _),
             .put(let path, _),
             .putWithData(let path, _, _),
             .delete(let path, _):
            return path
            
        case .checkIn(let spotId, _):
            return "spot/\(spotId)/check-in"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
            
        case .getLocationCategories(let locale):
            return ["locale": locale]
            
        case .getUser(let userRequest):
            return userRequest.toJSON()
            
        case .getUserWallets(let inactiveIncluded):
            return ["inactive_included" : inactiveIncluded]
            
        case .registerUser(let userRequest):
            return userRequest.toJSON()
            
        case .resetPassword(let userRequest):
            return userRequest.toJSON()
            
        case .changePassword(_, let userRequest):
            return userRequest.toJSON()
            
        case .verifyPhone(_, let code):
            return ["code": code]
            
        case .sendPhoneVerificationCode(_, let phone, let scopes):
            return ["phone": phone, "parameters" : ["scopes": scopes]]
            
        case .getLocations(let locationsRequest):
            return locationsRequest.toJSON()
            
        case .registerClient(let deviceInfo):
            return deviceInfo.toJSON()
            
        case .checkIn(_, let fields):
            return ["fields": fields]

        case .get(_, let parameters),
             .post(_, let parameters),
             .put(_, let parameters),
             .delete(_, let parameters):
            return parameters
            
        default:
            return nil
        }
    }
    
    // MARK: - Method
    public func asURLRequest() throws -> URLRequest {
        let url = try! WalletApiRequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
        case .putWithData(_, let data, let contentType):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
            
        case .checkIn(_, _):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)

            
        case (_) where method == .get,
             (_) where method == .delete:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case (_) where method == .post,
             (_) where method == .put:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)

        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        
        return urlRequest
    }
            
}
