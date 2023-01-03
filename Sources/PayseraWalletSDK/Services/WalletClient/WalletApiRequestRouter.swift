import Alamofire
import Foundation
import PayseraAccountsSDK
import PayseraCommonSDK

enum WalletApiRequestRouter {
    case get(path: String, parameters: [String: Any]?, extraParameters: [String: Any]?)
    case post(path: String, parameters: [String: Any]?)
    case put(path: String, parameters: [String: Any]?)
    case putWithData(path: String, data: Data, contentType: String)
    case delete(path: String, parameters: [String: Any]?)
    
    // GET
    case getLocations(PSGetLocationsRequest)
    case getLocationCategories(locale: String)
    case getCurrentUser
    case getUser(PSGetUserRequest)
    case getWallet(id: Int)
    case getWalletByFilter(filter: PSWalletFilter)
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
    case getStatements(walletId: Int, filter: PSStatementFilter?)
    case getCards(filter: PSCardFilter)
    case getPendingPayments(walletId: Int, filter: PSBaseFilter?)
    case getReservationStatements(walletId: Int, filter: PSBaseFilter?)
    case getIdentificationRequests(filter: PSIdentificationRequestsFilter)
    case getGenerator(generatorId: Int)
    case calculateCurrencyConversion(PSCurrencyConversion)
    case getCodeInformation(code: String)
    case getCard(cardId: Int)
    case getTransfers(filter: PSTransferFilter)
    case getUserServices(userId: Int)
    case getConfirmations(filter: PSConfirmationFilter)
    case getConfirmation(identifier: String)
    case getEasyPayFee(amount: PSMoney)
    case getEasyPayTransfers(filter: PSEasyPayTransferFilter?)

    // POST
    case registerClient(PSCreateClientRequest)
    case registerUser(PSUserRegistrationRequest)
    case resetPassword(PSPasswordResetRequest)
    case sendPhoneVerificationCode(userId: Int, phone: String, scopes: [String])
    case sendEmailVerificationCode(userId: Int, email: String)
    case createTransaction(PSTransaction)
    case createTransactionInProject(PSTransaction, projectId: Int, locationId: Int)
    case createTransactionRequest(key: String, request: PSTransactionRequest)
    case registerSubscriber(PSSubscriber)
    case generateCode(scopes: [String], parameters: PSGenerateCodeRequestParameters?)
    case createGenerator(code: String)
    case createContactBook(PSContactBookRequest)
    case convertCurrency(PSCurrencyConversion)
    case createCard(userId: Int, request: PSCardAccountRequest)
    case createIdentificationRequest(userId: Int)
    case createIdentityDocument(request: PSIdentificationDocumentRequest)
    case createAuthToken
    case createTransfer(PSTransfer)
    case createSimulatedTransfer(PSTransfer)
    case issueFirebaseToken
    case collectContact(PSContactCollectionRequest)
    case createAdditionalDocument(request: PSIdentificationDocumentRequest)
    case submitAdditionalDocument(documentID: Int, data: Data, contentType: String)
    case createEasyPayTransfer(amount: PSMoney, beneficiaryID: Int)

    // PUT
    case verifyPhone(userId: Int, code: String)
    case verifyEmail(userId: Int, code: String)
    case changePassword(userId: Int, PSPasswordChangeRequest)
    case checkIn(spotId: Int, fields: [String])
    case reserveTransaction(key: String, reservationCode: String)
    case confirmTransaction(key: String, projectId: Int, locationId: Int)
    case updateSubscriber(PSSubscriber, subscriberId: Int)
    case changeWalletDescription(walletId: Int, description: String)
    case reserveTransfer(transferId: Int)
    case signTransfer(transferId: Int)
    case unlockTransfer(transferId: Int, password: String)
    case provideUserPosition(position: PSUserPosition)
    case appendContactBook(contactBookId: Int, request: PSContactBookRequest)
    case enableUserService(userId: Int, service: String)
    case confirmConfirmation(identifier: String)
    case submitFacePhoto(requestId: Int, order: Int, data: Data, contentType: String)
    case submitDocumentPhoto(documentId: Int, order: Int, data: Data, contentType: String)
    case submitIdentificationRequest(requestId: Int)
    case uploadAvatar(imageData: Data, contentType: String)
    case rejectConfirmation(identifier: String)
    case cancelEasyPayTransfer(id: Int)

    // DELETE
    case deleteTransaction(key: String)
    case deleteSubscriber(subscriberId: Int)
    case deleteSubscribers
    case deleteWalletDescription(walletId: Int)
    case cancelTransfer(transferId: Int)
    case cancelPendingPayment(walletId: Int, pendingPaymentId: Int)
    case deleteFromContactBook(contactBookId: Int, request: PSContactBookRequest)
    case deleteCard(cardId: Int)
    case deleteAvatar
    
    // MARK: - Variables
    
    private static let baseURL = URL(string: "https://wallet-api.paysera.com/")!

    private var method: HTTPMethod {
        switch self {
        case .post,
             .registerClient,
             .registerUser,
             .resetPassword,
             .sendPhoneVerificationCode,
             .sendEmailVerificationCode,
             .createTransaction,
             .createTransactionInProject,
             .createTransactionRequest,
             .registerSubscriber,
             .generateCode,
             .createGenerator,
             .createContactBook,
             .convertCurrency,
             .createCard,
             .createIdentificationRequest,
             .createIdentityDocument,
             .createAuthToken,
             .createTransfer,
             .createSimulatedTransfer,
             .issueFirebaseToken,
             .collectContact,
             .createAdditionalDocument,
             .submitAdditionalDocument,
             .createEasyPayTransfer:
            return .post
            
        case .get,
             .getLocationCategories,
             .getCurrentUser,
             .getUser,
             .getLocations,
             .getWallet,
             .getWalletByFilter,
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
             .getStatements,
             .getCards,
             .getPendingPayments,
             .getReservationStatements,
             .getIdentificationRequests,
             .getGenerator,
             .calculateCurrencyConversion,
             .getCodeInformation,
             .getCard,
             .getTransfers,
             .getUserServices,
             .getConfirmations,
             .getConfirmation,
             .getEasyPayFee,
             .getEasyPayTransfers:
            return .get
            
        case .put,
             .putWithData,
             .verifyPhone,
             .verifyEmail,
             .changePassword,
             .reserveTransaction,
             .checkIn,
             .confirmTransaction,
             .updateSubscriber,
             .changeWalletDescription,
             .reserveTransfer,
             .signTransfer,
             .unlockTransfer,
             .provideUserPosition,
             .appendContactBook,
             .enableUserService,
             .rejectConfirmation,
             .confirmConfirmation,
             .submitFacePhoto,
             .submitDocumentPhoto,
             .submitIdentificationRequest,
             .uploadAvatar,
             .cancelEasyPayTransfer:
            return .put
            
        case .delete,
             .deleteTransaction,
             .deleteSubscriber,
             .deleteSubscribers,
             .deleteWalletDescription,
             .cancelTransfer,
             .cancelPendingPayment,
             .deleteFromContactBook,
             .deleteCard,
             .deleteAvatar:
            return .delete
        }

    }
    
    private var path: String {
        servicePath + endpointPath
    }

    private var servicePath: String {
        switch self {
        case .getEasyPayFee,
             .createEasyPayTransfer,
             .cancelEasyPayTransfer,
             .getEasyPayTransfers:
            return "epay/rest/v1/"
        default:
            return "rest/v1/"
        }
    }

    private var endpointPath: String {
        switch self {
        case .getTransaction(let key, _):
            return "transaction/\(key)"
            
        case .reserveTransaction(let key, _):
            return "transaction/\(key)/reserve"
            
        case .createTransaction,
             .createTransactionInProject:
            return "transaction"
        
        case .createTransactionRequest(let key, _):
            return "transaction/\(key)/request"
            
        case .getCurrentUser:
            return "user/me"
            
        case .verifyPhone(let userId, _):
            return "user/\(userId)/phone/confirm"
            
        case .verifyEmail(userId: let userId, _):
            return "user/\(userId)/email/confirm"
            
        case .getUser,
             .registerUser:
            return "user"
            
        case .getSpot(let id, _):
            return "spot/\(id)"
            
        case .getTransfer(let id):
            return "transfers/\(id)"
            
        case .resetPassword:
            return "user/password/reset"
        
        case .getWalletByFilter:
            return "wallet"
            
        case .getWallet(let id):
            return "wallet/\(id)"
            
        case .getWallets:
            return "wallets"
            
        case .getUserWallets:
            return "user/me/wallets"
            
        case .getStatements(let walletId, _):
            return "wallet/\(walletId)/statements"
            
        case .sendPhoneVerificationCode(let userId, _, _):
            return "user/\(userId)/phone"
            
        case .sendEmailVerificationCode(let userId, _):
            return "user/\(userId)/email"
            
        case .changePassword(let userId, _):
            return "user/\(userId)/password"
            
        case .registerClient:
            return "client"
            
        case .getLocations:
            return "locations"
            
        case .getLocationCategories:
            return "locations/pay-categories"
            
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
            return "transactions"
        
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
            
        case .getCards:
            return "cards"
            
        case .changeWalletDescription(let walletId, _):
            return "wallet/\(walletId)"
            
        case .deleteWalletDescription(let walletId):
            return "wallet/\(walletId)/description"
            
        case .reserveTransfer(let transferId):
            return "transfers/\(transferId)/reserve"
            
        case .signTransfer(let transferId):
            return "transfers/\(transferId)/sign"
            
        case .cancelTransfer(let transferId):
            return "transfers/\(transferId)"
            
        case .unlockTransfer(let transferId, _):
            return "transfers/\(transferId)/provide-password"
            
        case .getPendingPayments(let walletId, _):
            return "wallet/\(walletId)/pending-payments"
            
        case .getReservationStatements(let walletId, _):
            return "wallet/\(walletId)/reservation-statements"
            
        case .cancelPendingPayment(let walletId, let pendingPaymentId):
            return "wallet/\(walletId)/pending-payment/\(pendingPaymentId)"
            
        case .generateCode:
            return "generator/code"
            
        case .createGenerator:
            return "generator"
            
        case .getGenerator(let generatorId):
            return "generator/\(generatorId)"
            
        case .provideUserPosition:
            return "user/me/position"
            
        case .getIdentificationRequests:
            return "user/me/identification-requests"
            
        case .createContactBook:
            return "user/me/contact-book"
            
        case .appendContactBook(let contactBookId, _):
            return "contact-book/\(contactBookId)/append"
            
        case .deleteFromContactBook(let contactBookId, _):
             return "contact-book/\(contactBookId)/contacts"
            
        case .calculateCurrencyConversion,
             .convertCurrency:
            return "currency-conversion"
            
        case .getCodeInformation:
            return "code"
            
        case .createCard:
            return "card"
            
        case .getCard(let cardId),
             .deleteCard(let cardId):
            return "card/\(cardId)"
            
        case .getTransfers:
            return "transfers"
            
        case .getUserServices(let userId):
            return "user/\(userId)/services"
            
        case .enableUserService(let userId, let service):
            return "user/\(userId)/service/\(service)"
            
        case .getConfirmations:
            return "confirmations/me"
            
        case .getConfirmation(let identifier):
            return "confirmations/\(identifier)"
            
        case .rejectConfirmation(let identifier):
            return "confirmations/\(identifier)/reject"
            
        case .confirmConfirmation(let identifier):
            return "confirmations/\(identifier)/confirm"
            
        case .createIdentificationRequest(let userId):
            return "user/\(userId)/identification-request"
            
        case .createIdentityDocument(let request):
            return "identification-request/\(request.id!)/identity-document"
        
        case .submitFacePhoto(let requestId, let order, _, _):
            return "identification-request/\(requestId)/face-photo/image/\(order)"
            
        case .submitDocumentPhoto(let documentId, let order, _, _):
            return "identity-document/\(documentId)/image/\(order)"
            
        case .submitIdentificationRequest(let requestId):
            return "identification-request/\(requestId)/submit"
            
        case .uploadAvatar,
             .deleteAvatar:
            return "user/me/avatar"
            
        case .createAuthToken:
            return "auth-token/token"
            
        case .createTransfer:
            return "transfers"
            
        case .createSimulatedTransfer:
            return "simulated-transfers"
            
        case .issueFirebaseToken:
            return "mobile-application-integration/firebase/tokens"
          
        case .collectContact:
            return "contacts"
            
        case .createAdditionalDocument(let request):
            return "identification-request/\(request.id!)/additional-document"
            
        case .submitAdditionalDocument(let documentID, _, _):
            return "additional-document/\(documentID)/file"
            
        case .getEasyPayFee:
            return "fees"

        case .createEasyPayTransfer:
            return "transfers"

        case .cancelEasyPayTransfer(let id):
            return "transfers/\(id)/cancel"

        case .getEasyPayTransfers:
            return "transfers"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        
        case .getTransaction(_, let fields):
            return ["fields": fields.joined(separator: ",")]
            
        case .reserveTransaction(_, let reservationCode):
            return ["reservation_code": reservationCode]
            
        case .createTransaction(let transaction),
             .createTransactionInProject(let transaction, _, _):
            return transaction.toJSON()
            
        case .createTransactionRequest(_, let request):
            return request.toJSON()
            
        case .getLocationCategories(let locale):
            return ["locale": locale]
            
        case .getUser(let userRequest):
            return userRequest.toJSON()
        
        case .getWalletByFilter(let filter):
            return filter.toJSON()
            
        case .getWallets(let filter):
            return filter.toJSON()
            
        case .getSpot(_, let fields):
            return ["fields": fields.joined(separator: ",")]
            
        case .getUserWallets(let inactiveIncluded):
            return ["inactive_included" : inactiveIncluded]
            
        case .getStatements(_, let filter):
            return filter?.toJSON()
            
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
            
        case .sendEmailVerificationCode(_, let email):
            return ["email": email]
            
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
            
        case .getCards(let filter):
            return filter.toJSON()
            
        case .changeWalletDescription(_, let description):
            return ["description": description]
            
        case .unlockTransfer(_, let password):
            return ["password": password]
            
        case .getPendingPayments(_, let filter),
             .getReservationStatements(_, let filter):
            return filter?.toJSON()
        
        case .generateCode(let scopes, let parameters):
            var json = parameters?.toJSON() ?? [:]
            json["scopes"] = scopes
            return json
        
        case .createGenerator(let code):
            return ["code": code]
            
        case .provideUserPosition(let position):
            return position.toJSON()
        
        case .getIdentificationRequests(let filter):
            return filter.toJSON()
            
        case .createContactBook(let request),
             .appendContactBook(_, let request):
            return request.toJSON()
            
        case .deleteFromContactBook(_, let request):
            let parameters = [
                "email": request.emails?.joined(separator: ","),
                "phone": request.phones?.joined(separator: ","),
                "email_hash": request.emailHashes?.joined(separator: ","),
                "phone_hash": request.phoneHashes?.joined(separator: ","),
            ]
            return parameters.compactMapValues { $0 }
            
        case .calculateCurrencyConversion(let request):
            return request.toJSON()
        
        case .convertCurrency(let request):
            return request.toJSON()
            
        case .getCodeInformation(let code):
            return ["code": code]
            
        case .createCard(let userId, let request):
            var requestJSON = request.toJSON()
            requestJSON["user_id"] = userId
            return requestJSON
            
        case .getTransfers(let filter):
            return filter.toJSON()
            
        case .getConfirmations(let filter):
            return filter.toJSON()
            
        case .createIdentificationRequest:
            return [:]
            
        case .createIdentityDocument(let request):
            return request.toJSON()
            
        case .createTransfer(let transfer),
             .createSimulatedTransfer(let transfer):
            return transfer.toJSON()
        
        case .collectContact(let payload):
            return payload.toJSON()
        
        case .createAdditionalDocument(let request):
            return request.toJSON()
            
        case .getEasyPayFee(let amount):
            return amount.toJSON()

        case .createEasyPayTransfer(let amount, let beneficiaryID):
            var data = amount.toJSON()
            data["beneficiary_id"] = beneficiaryID
            return data

        case .getEasyPayTransfers(let filter):
            return filter?.toJSON()
            
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
}

extension WalletApiRequestRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        var extraParametersString = ""
        extraParameters?.forEach {
            extraParametersString.append("&\($0.key)=\($0.value)")
        }
        urlRequest.addValue(extraParametersString, forHTTPHeaderField: "extraParameters")
        
        switch self {
        case .putWithData(_, let data, let contentType),
             .uploadAvatar(let data, let contentType),
             .submitFacePhoto(_, _, let data, let contentType),
             .submitDocumentPhoto(_, _, let data, let contentType),
             .submitAdditionalDocument(_, let data, let contentType):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
            
        case .checkIn:
            urlRequest.url = try! "\(urlRequest.url!.absoluteString)?\(parameters!.queryString)".asURL()
            
        case _ where method == .get,
             _ where method == .delete:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case _ where method == .post,
             _ where method == .put:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)

        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
