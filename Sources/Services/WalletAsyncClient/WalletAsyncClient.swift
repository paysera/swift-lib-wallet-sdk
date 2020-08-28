import Foundation
import Alamofire
import ObjectMapper
import PromiseKit
import PayseraCommonSDK
import PayseraAccountsSDK

public class WalletAsyncClient: BaseAsyncClient {
    
    public func registerNewAuthClient(deviceInfo: PSCreateClientRequest) -> Promise<PSClient> {
        return doRequest(requestRouter: WalletApiRequestRouter.registerClient(deviceInfo))
    }
    
    public func getLocations(locationRequest: PSGetLocationsRequest) -> Promise<PSMetadataAwareResponse<PSLocation>> {
        return doRequest(requestRouter: WalletApiRequestRouter.getLocations(locationRequest))
    }
    
    public func getLocationsCategories(locale: String) -> Promise<[PSLocationCategory]> {
        return doRequest(requestRouter: WalletApiRequestRouter.getLocationCategories(locale: locale))
    }
    
    public func getUser(_ getUserRequest: PSGetUserRequest) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.getUser(getUserRequest))
    }
    
    public func getSpot(byId id: Int, fields: [String] = []) -> Promise<PSSpot> {
        return doRequest(requestRouter: WalletApiRequestRouter.getSpot(id: id, fields: fields))
    }
    
    public func checkIn(spotId: Int, fields: [String]) -> Promise<PSSpot> {
        return doRequest(requestRouter: WalletApiRequestRouter.checkIn(spotId: spotId, fields: fields))
    }
    
    public func registerUser(_ registerUserRequest: PSUserRegistrationRequest) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.registerUser(registerUserRequest))
    }
    
    public func verifyPhone(userId: Int, code: String) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.verifyPhone(userId: userId, code: code))
    }
    
    public func verifyEmail(userId: Int, code: String) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.verifyEmail(userId: userId, code: code))
    }
    
    public func getWallet(byId id: Int) -> Promise<PSWallet> {
        return doRequest(requestRouter: WalletApiRequestRouter.getWallet(id: id))
    }
    
    public func getWallet(filter: PSWalletFilter) -> Promise<PSWallet> {
        return doRequest(requestRouter: WalletApiRequestRouter.getWalletByFilter(filter: filter))
    }
    
    public func getWallets(filter: PSWalletsFilter) -> Promise<PSGetWalletsResponse> {
        return doRequest(requestRouter: WalletApiRequestRouter.getWallets(filter))
    }
    
    public func getUserWallets(inactiveIncluded: String) -> Promise<[PSWallet]> {
        return doRequest(requestRouter: WalletApiRequestRouter.getUserWallets(inactiveIncluded: inactiveIncluded))
    }
    
    public func resetPassword(_ passwordResetRequest: PSPasswordResetRequest) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.resetPassword(passwordResetRequest))
    }
    
    public func sendPhoneVerificationCode(userId: Int, phone: String, scopes: [String]) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.sendPhoneVerificationCode(userId: userId, phone: phone, scopes: scopes))
    }
    
    public func sendEmailVerificationCode(userId: Int, email: String) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.sendEmailVerificationCode(userId: userId, email: email))
    }
    
    public func changePassword(userId: Int, changePasswordRequest: PSPasswordChangeRequest) -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.changePassword(userId: userId, changePasswordRequest))
    }
    
    public func getTransaction(byKey key: String, fields: [String] = []) -> Promise<PSTransaction> {
        return doRequest(requestRouter: WalletApiRequestRouter.getTransaction(key: key, fields: fields))
    }
    
    public func reserveTransaction(key: String, reservationCode: String) -> Promise<PSTransaction> {
        return doRequest(requestRouter: WalletApiRequestRouter.reserveTransaction(key: key, reservationCode: reservationCode))
    }
    
    public func createTransaction(transaction: PSTransaction) -> Promise<PSTransaction> {
        return doRequest(requestRouter: WalletApiRequestRouter.createTransaction(transaction))
    }
    
    public func createTransaction(transaction: PSTransaction, projectId: Int, locationId: Int) -> Promise<PSTransaction> {
        return doRequest(requestRouter: WalletApiRequestRouter.createTransactionInProject(transaction, projectId: projectId, locationId: locationId))
    }
    
    public func createTransactionRequest(key: String, request: PSTransactionRequest) -> Promise<PSTransactionRequest> {
        return doRequest(requestRouter: WalletApiRequestRouter.createTransactionRequest(key: key, request: request))
    }
    
    public func get(path: String, parameters: [String: Any]? = nil, extraParameters: [String: Any]? = nil) -> Promise<String> {
        let request = createRequest(WalletApiRequestRouter.get(path: path, parameters: parameters, extraParameters: extraParameters))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func post(path: String, parameters: [String: Any]? = nil) -> Promise<String> {
        let request = createRequest(WalletApiRequestRouter.post(path: path, parameters: parameters))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func put(path: String, parameters: [String: Any]? = nil) -> Promise<String> {
        let request = createRequest(WalletApiRequestRouter.put(path: path, parameters: parameters))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func put(path: String, data: Data, contentType: String) -> Promise<String> {
        let request = createRequest(WalletApiRequestRouter.putWithData(path: path, data: data, contentType: contentType))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func delete(path: String, parameters: [String: Any]? = nil) -> Promise<String> {
        let request = createRequest(WalletApiRequestRouter.delete(path: path, parameters: parameters))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func getCurrentUser() -> Promise<PSUser> {
        return doRequest(requestRouter: WalletApiRequestRouter.getCurrentUser)
    }
    
    public func getProjects() -> Promise<[PSProject]> {
        return doRequest(requestRouter: WalletApiRequestRouter.getProjects)
    }
    
    public func getProjects(_ fields: [String]) -> Promise<[PSProject]> {
        return doRequest(requestRouter: WalletApiRequestRouter.getProjectsWithFields(fields: fields))
    }
    
    public func getProjectLocations(id: Int) -> Promise<[PSLocation]> {
        return doRequest(requestRouter: WalletApiRequestRouter.getProjectLocations(id: id))
    }
    
    public func getProjectTransactions(filter: PSTransactionFilter) -> Promise<PSMetadataAwareResponse<PSTransaction>> {
        return doRequest(requestRouter: WalletApiRequestRouter.getProjectTransactions(filter: filter))
    }
    
    public func confirmTransaction(key: String, projectId: Int, locationId: Int) -> Promise<PSTransaction> {
        return doRequest(requestRouter: WalletApiRequestRouter.confirmTransaction(key: key, projectId: projectId, locationId: locationId))
    }
    
    public func deleteTransaction(key: String) -> Promise<PSTransaction> {
        return doRequest(requestRouter: WalletApiRequestRouter.deleteTransaction(key: key))
    }
    
    public func registerSubscriber(_ psSubscriber: PSSubscriber) -> Promise<PSSubscriber> {
        return doRequest(requestRouter: WalletApiRequestRouter.registerSubscriber(psSubscriber))
    }
    
    public func updateSubscriber(_ psSubscriber: PSSubscriber, subscriberId: Int) -> Promise<PSSubscriber> {
        return doRequest(requestRouter: WalletApiRequestRouter.updateSubscriber(psSubscriber, subscriberId: subscriberId))
    }
    
    public func getEvents(filter: PSEventsFilter) -> Promise<PSMetadataAwareResponse<PSEvent>> {
        return doRequest(requestRouter: WalletApiRequestRouter.getEvents(filter: filter))
    }
    
    public func deleteSubscriber(subscriberId: Int) -> Promise<PSSubscriber> {
        return doRequest(requestRouter: WalletApiRequestRouter.deleteSubscriber(subscriberId: subscriberId))
    }
    
    public func deleteSubscribers() -> Promise<[PSSubscriber]> {
        return doRequest(requestRouter: WalletApiRequestRouter.deleteSubscribers)
    }
    
    public func getStatements(
        walletId: Int,
        filter: PSStatementFilter? = nil
    ) -> Promise<PSMetadataAwareResponse<PSStatement>> {
        doRequest(requestRouter: WalletApiRequestRouter.getStatements(walletId: walletId, filter: filter))
    }
    
    public func getCards(filter: PSCardFilter) -> Promise<PSMetadataAwareResponse<PSCard>> {
        doRequest(requestRouter: WalletApiRequestRouter.getCards(filter: filter))
    }
    
    public func changeWalletDescription(walletId: Int, description: String) -> Promise<PSWallet> {
        doRequest(requestRouter: WalletApiRequestRouter.changeWalletDescription(walletId: walletId, description: description))
    }
    
    public func deleteWalletDescription(walletId: Int) -> Promise<PSWallet> {
        doRequest(requestRouter: WalletApiRequestRouter.deleteWalletDescription(walletId: walletId))
    }
    
    public func getTransfer(transferId: Int) -> Promise<PSTransfer> {
        return doRequest(requestRouter: WalletApiRequestRouter.getTransfer(id: transferId))
    }

    public func reserveTransfer(transferId: Int) -> Promise<PSTransfer> {
        doRequest(requestRouter: WalletApiRequestRouter.reserveTransfer(transferId: transferId))
    }
    
    public func signTransfer(transferId: Int) -> Promise<PSTransfer> {
        doRequest(requestRouter: WalletApiRequestRouter.signTransfer(transferId: transferId))
    }
    
    public func cancelTransfer(transferId: Int) -> Promise<PSTransfer> {
        doRequest(requestRouter: WalletApiRequestRouter.cancelTransfer(transferId: transferId))
    }
    
    public func unlockTransfer(transferId: Int, password: String) -> Promise<PSTransfer> {
        doRequest(requestRouter: WalletApiRequestRouter.unlockTransfer(transferId: transferId, password: password))
    }
    
    public func getPendingPayments(walletId: Int, filter: PSBaseFilter? = nil) -> Promise<PSMetadataAwareResponse<PSPendingPayment>> {
        doRequest(requestRouter: WalletApiRequestRouter.getPendingPayments(walletId: walletId, filter: filter))
    }
    
    public func getReservationStatements(walletId: Int, filter: PSBaseFilter? = nil) -> Promise<PSMetadataAwareResponse<PSReservationStatement>> {
        doRequest(requestRouter: WalletApiRequestRouter.getReservationStatements(walletId: walletId, filter: filter))
    }
    
    public func cancelPendingPayment(walletId: Int, pendingPaymentId: Int) -> Promise<PSPendingPayment> {
        doRequest(requestRouter: WalletApiRequestRouter.cancelPendingPayment(walletId: walletId, pendingPaymentId: pendingPaymentId))
    }
    
    public func generateCode(scopes: [String]) -> Promise<PSGeneratorResponse> {
        doRequest(requestRouter: WalletApiRequestRouter.generateCode(scopes: scopes))
    }
    
    public func createGenerator(code: String) -> Promise<PSGenerator> {
        doRequest(requestRouter: WalletApiRequestRouter.createGenerator(code: code))
    }
    
    public func getGenerator(generatorId: Int) -> Promise<PSGenerator> {
        doRequest(requestRouter: WalletApiRequestRouter.getGenerator(generatorId: generatorId))
    }
    
    public func provideUserPosition(_ position: PSUserPosition) -> Promise<PSUserPosition> {
        doRequest(requestRouter: WalletApiRequestRouter.provideUserPosition(position: position))
    }
    
    public func getIdentificationRequests(filter: PSIdentificationRequestsFilter) -> Promise<PSMetadataAwareResponse<PSIdentificationRequest>> {
        doRequest(requestRouter: WalletApiRequestRouter.getIdentificationRequests(filter: filter))
    }
    
    public func createContactBook(request: PSContactBookRequest) -> Promise<PSContactBookResponse> {
        doRequest(requestRouter: WalletApiRequestRouter.createContactBook(request))
    }
    
    public func appendContactBook(contactBookId: Int, request: PSContactBookRequest) -> Promise<PSContactBookResponse> {
        doRequest(requestRouter: WalletApiRequestRouter.appendContactBook(contactBookId: contactBookId, request: request))
    }
    
    public func deleteFromContactBook(contactBookId: Int, request: PSContactBookRequest) -> Promise<Void> {
        doRequest(requestRouter: WalletApiRequestRouter.deleteFromContactBook(contactBookId: contactBookId, request: request))
    }
    
    public func calculateCurrencyConversion(request: PSCurrencyConversion) -> Promise<PSCurrencyConversion> {
        doRequest(requestRouter: WalletApiRequestRouter.calculateCurrencyConversion(request))
    }
    
    public func convertCurrency(request: PSCurrencyConversion) -> Promise<PSCurrencyConversionResponse> {
        doRequest(requestRouter: WalletApiRequestRouter.convertCurrency(request))
    }
    
    public func getCodeInformation(code: String) -> Promise<PSCodeInformation> {
        doRequest(requestRouter: WalletApiRequestRouter.getCodeInformation(code: code))
    }
    
    public func createCard(userId: Int, request: PSCardAccountRequest) -> Promise<PSCard> {
        doRequest(requestRouter: WalletApiRequestRouter.createCard(userId: userId, request: request))
    }
    
    public func getCard(cardId: Int) -> Promise<PSCard> {
        doRequest(requestRouter: WalletApiRequestRouter.getCard(cardId: cardId))
    }
    
    public func deleteCard(cardId: Int) -> Promise<Void> {
        doRequest(requestRouter: WalletApiRequestRouter.deleteCard(cardId: cardId))
    }
    
    public func getTransfers(filter: PSTransferFilter) -> Promise<PSMetadataAwareResponse<PSTransfer>> {
        doRequest(requestRouter: WalletApiRequestRouter.getTransfers(filter: filter))
    }
    
    public func getUserServices(userId: Int) -> Promise<PSUserServiceResponse> {
        doRequest(requestRouter: WalletApiRequestRouter.getUserServices(userId: userId))
    }
    
    public func enableUserService(userId: Int, service: String) -> Promise<PSUserService> {
        doRequest(requestRouter: WalletApiRequestRouter.enableUserService(userId: userId, service: service))
    }
    
    public func getConfirmations(filter: PSConfirmationFilter) -> Promise<PSMetadataAwareResponse<PSConfirmation>> {
        doRequest(requestRouter: WalletApiRequestRouter.getConfirmations(filter: filter))
    }
    
    public func getConfirmation(identifier: String) -> Promise<PSConfirmation> {
        doRequest(requestRouter: WalletApiRequestRouter.getConfirmation(identifier: identifier))
    }
    
    public func rejectConfirmation(identifier: String) -> Promise<PSConfirmation> {
        doRequest(requestRouter: WalletApiRequestRouter.rejectConfirmation(identifier: identifier))
    }
    
    public func confirmConfirmation(identifier: String) -> Promise<PSConfirmation> {
        doRequest(requestRouter: WalletApiRequestRouter.confirmConfirmation(identifier: identifier))
    }
    
    public func createIdentificationRequest(userId: Int) -> Promise<PSIdentificationRequest> {
        doRequest(requestRouter: WalletApiRequestRouter.createIdentificationRequest(userId: userId))
    }
    
    public func createIdentityDocument(request: PSIdentificationDocumentRequest) -> Promise<PSIdentityDocument> {
        doRequest(requestRouter: WalletApiRequestRouter.createIdentityDocument(request: request))
    }
    
    public func uploadAvatar(imageData: Data, contentType: String) -> Promise<Void> {
        doRequest(requestRouter: WalletApiRequestRouter.uploadAvatar(imageData: imageData, contentType: contentType))
    }
    
    public func submitFacePhoto(requestId: Int, order: Int, data: Data, contentType: String) -> Promise<Void> {
        doRequest(
            requestRouter: WalletApiRequestRouter.submitFacePhoto(
                requestId: requestId,
                order: order,
                data: data,
                contentType: contentType
            )
        )
    }
    
    public func submitDocumentPhoto(documentId: Int, order: Int, data: Data, contentType: String) -> Promise<Void> {
        doRequest(
            requestRouter: WalletApiRequestRouter.submitDocumentPhoto(
                documentId: documentId,
                order: order,
                data: data,
                contentType: contentType
            )
        )
    }
    
    public func submitIdentificationRequest(requestId: Int) -> Promise<Void> {
        doRequest(requestRouter: WalletApiRequestRouter.submitIdentificationRequest(requestId: requestId))
    }
    
    public func deleteAvatar() -> Promise<Void> {
        doRequest(requestRouter: WalletApiRequestRouter.deleteAvatar)
    }
    
    public func createAuthToken() -> Promise<PSAuthTokenResponse> {
        doRequest(requestRouter: WalletApiRequestRouter.createAuthToken)
    }
    
    public func createTransfer(_ transfer: PSTransfer, isSimulated: Bool) -> Promise<PSTransfer> {
        doRequest(requestRouter: WalletApiRequestRouter.createTransfer(transfer, isSimulated: isSimulated))
    }
    
    public func issueFirebaseToken() -> Promise<PSFirebaseTokenResponse> {
        doRequest(requestRouter: WalletApiRequestRouter.issueFirebaseToken)
    }
}
