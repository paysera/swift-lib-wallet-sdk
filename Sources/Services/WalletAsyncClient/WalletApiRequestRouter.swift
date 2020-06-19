import Alamofire
import PayseraCommonSDK

public enum WalletApiRequestRouter: URLRequestConvertible {
    case get(path: String, parameters: [String: Any]?, extraParameters: [String: Any]?)
    case post(path: String, parameters: [String: Any]?)
    case put(path: String, parameters: [String: Any]?)
    case putWithData(path: String, data: Data, contentType: String)
    case delete(path: String, parameters: [String: Any]?)
    
    // MARK: - GET
    case getLocations(PSGetLocationsRequest)
    case getLocationCategories(locale: String)
    case getCurrentUser
    case getUser(PSGetUserRequest)
    case getWallet(id: Int)
    case getWallets(PSWalletsFilter)
    case getUserWallets(inactiveIncluded: String)
    case getSpot(id: Int, fields: [String])
    case getTransfer(id: Int)
    case getTransaction(key: String, fields: [String])
    case getProjects
    case getProjectsWithFields(fields: [String])
    case getProjectLocations(id: Int)
    case getProjectTransactions(filter: PSTransactionFilter)
    case getEvents(filter: PSEventsFilter)
    case getWalletStatements(id: Int, from: Int, to: Int, limit: Int)
    
    // MARK: - POST
    case registerClient(PSCreateClientRequest)
    case registerUser(PSUserRegistrationRequest)
    case resetPassword(PSPasswordResetRequest)
    case sendPhoneVerificationCode(userId: Int, phone: String, scopes: [String])
    case changePassword(userId: Int, PSPasswordChangeRequest)
    case createTransaction(PSTransaction)
    case createTransactionInProject(PSTransaction, projectId: Int, locationId: Int)
    case createTransactionRequest(key: String, request: PSTransactionRequest)
    case registerSubscriber(PSSubscriber)
    
    // MARK: - Put
    case verifyPhone(userId: Int, code: String)
    case verifyEmail(userId: Int, code: String)
    case checkIn(spotId: Int, fields: [String])
    case reserveTransaction(key: String, reservationCode: String)
    case confirmTransaction(key: String, projectId: Int, locationId: Int)
    case updateSubscriber(PSSubscriber, subscriberId: Int)
    
    // MARK: - Delete
    case deleteTransaction(key: String)
    case deleteSubscriber(subscriberId: Int)
    case deleteSubscribers
    
    // MARK: - Variables
    static var baseURLString = "https://wallet-api.paysera.com/rest/v1"

    private var method: HTTPMethod {
        switch self {
        case .post,
             .registerClient,
             .registerUser,
             .resetPassword,
             .sendPhoneVerificationCode,
             .createTransaction,
             .createTransactionInProject,
             .createTransactionRequest,
             .registerSubscriber:
            return .post
            
        case .get,
             .getLocationCategories,
             .getCurrentUser,
             .getUser,
             .getLocations,
             .getWallet,
             .getUserWallets,
             .getSpot,
             .getTransfer,
             .getTransaction,
             .getWallets,
             .getProjects,
             .getProjectsWithFields,
             .getProjectLocations,
             .getProjectTransactions,
             .getEvents,
             .getWalletStatements:
            return .get
            
        case .put,
             .putWithData,
             .verifyPhone,
             .verifyEmail,
             .changePassword,
             .reserveTransaction,
             .checkIn,
             .confirmTransaction,
             .updateSubscriber:
            return .put
            
        case .delete(_, _),
             .deleteTransaction(_),
             .deleteSubscriber,
             .deleteSubscribers:
            return .delete
        }

    }
    
    private var path: String {
        switch self {
        case .getTransaction(let key, _):
            return "transaction/\(key)"
            
        case .reserveTransaction(let key, _):
            return "transaction/\(key)/reserve"
            
        case .createTransaction,
             .createTransactionInProject:
            return "/transaction"
        
        case .createTransactionRequest(let key, _):
            return "/transaction/\(key)/request"
            
        case .getCurrentUser:
            return "/user/me"
            
        case .verifyPhone(let userId, _):
            return "/user/\(userId)/phone/confirm"
            
        case .verifyEmail(userId: let userId, _):
            return "/user/\(userId)/email/confirm"
            
        case .getUser,
             .registerUser:
            return "/user"
            
        case .getSpot(let id, _):
            return "spot/\(id)"
            
        case .getTransfer(let id):
            return "transfers/\(id)"
            
        case .resetPassword:
            return "/user/password/reset"
            
        case .getWallet(let id):
            return "/wallet/\(id)"
            
        case .getWallets:
            return "/wallets"
            
        case .getUserWallets:
            return "user/me/wallets"
            
        case .getWalletStatements(let id, _, _, _):
            return "/wallet/\(id)/statements"
            
        case .sendPhoneVerificationCode(let userId, _, _):
            return "/user/\(userId)/phone"
            
        case .changePassword(let userId, _):
            return "/user/\(userId)/password"
            
        case .registerClient:
            return "/client"
            
        case .getLocations:
            return "/locations"
            
        case .getLocationCategories:
            return "/locations/pay-categories"
            
        case .get(let path, _, _),
             .post(let path, _),
             .put(let path, _),
             .putWithData(let path, _, _),
             .delete(let path, _):
            return path
            
        case .checkIn(let spotId, _):
            return "spot/\(spotId)/check-in"
        
        case .getProjects,
             .getProjectsWithFields:
            return "user/me/projects"
        
        case .getProjectLocations:
            return "client/locations"
            
        case .getProjectTransactions:
            return "/transactions"
        
        case .confirmTransaction(let key, _, _):
            return "transaction/\(key)/confirm"
            
        case .registerSubscriber:
            return "subscriber"
            
        case .updateSubscriber(_, let subscriberId),
             .deleteSubscriber(let subscriberId):
            return "subscriber/\(subscriberId)"
            
        case .getEvents:
            return "events"
            
        case .deleteTransaction(let key):
            return "transaction/\(key)"
            
        case .deleteSubscribers:
            return "subscribers"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        
        case .getTransaction(_, let fields):
            return ["fields": fields.joined(separator: ",")]
            
        case .reserveTransaction(_, let reservationCode):
            return ["reservation_code": reservationCode]
            
        case .createTransaction(let transaction), .createTransactionInProject(let transaction, _, _):
            return transaction.toJSON()
            
        case .createTransactionRequest(_, let request):
            return request.toJSON()
            
        case .getLocationCategories(let locale):
            return ["locale": locale]
            
        case .getUser(let userRequest):
            return userRequest.toJSON()
            
        case .getWallets(let filter):
            return filter.toJSON()
            
        case .getSpot(_, let fields):
            return ["fields": fields.joined(separator: ",")]
            
        case .getUserWallets(let inactiveIncluded):
            return ["inactive_included" : inactiveIncluded]
            
        case .getWalletStatements(_, let from, let to, let limit):
            return [
                "from": from,
                "to": to,
                "limit": limit
            ]
            
        case .registerUser(let userRequest):
            return userRequest.toJSON()
            
        case .resetPassword(let userRequest):
            return userRequest.toJSON()
            
        case .changePassword(_, let userRequest):
            return userRequest.toJSON()
            
        case .verifyPhone(_, let code):
            return ["code": code]
            
        case .verifyEmail(_, let code):
            return ["code": code]
            
        case .sendPhoneVerificationCode(_, let phone, let scopes):
            return ["phone": phone, "parameters" : ["scopes": scopes]]
            
        case .getLocations(let locationsRequest):
            return locationsRequest.toJSON()
            
        case .registerClient(let deviceInfo):
            return deviceInfo.toJSON()
            
        case .checkIn(_, let fields):
            return ["fields": fields.joined(separator: ",")]
            
        case .getProjectTransactions(let filter):
            return filter.toJSON()

        case .get(_, let parameters, _),
             .post(_, let parameters),
             .put(_, let parameters),
             .delete(_, let parameters):
            return parameters
        
        case .getProjectsWithFields(let fields):
            return ["fields": fields.joined(separator: ",")]
            
        case .registerSubscriber(let subscriber):
            return subscriber.toJSON()
            
        case .updateSubscriber(let subscriber, _):
            return subscriber.toJSON()
            
        case .getEvents(let filter):
            return filter.toJSON()

        default:
            return nil
        }
    }
    
    private var extraParameters: [String: Any]? {
        switch self {
        case .getProjectLocations(let id):
            return ["project_id": id]
            
        case .createTransactionInProject(_, let projectId, let locationId):
            return ["project_id": projectId, "location_id": locationId]
            
        case .get(_, _, let extraParameters):
            return extraParameters
            
        case .confirmTransaction(_, let projectId, let locationId):
            return ["project_id": projectId, "location_id": locationId]
            
        default:
            return nil
        }
    }
    
    // MARK: - Method
    public func asURLRequest() throws -> URLRequest {
        let url = try! WalletApiRequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        var extraParametersString = ""
         extraParameters?.forEach {
             extraParametersString.append("&\($0.key)=\($0.value)")
         }
        urlRequest.addValue(extraParametersString, forHTTPHeaderField: "extraParameters")
        switch self {
            
        case .putWithData(_, let data, let contentType):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
            
        case .checkIn(_, _):
            urlRequest.url = try! "\(urlRequest.url!.absoluteString)?\(parameters!.queryString)".asURL()
            
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
