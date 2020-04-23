import Foundation
import Alamofire
import ObjectMapper
import PromiseKit
import PayseraCommonSDK

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
        return doRequest(requestRouter: WalletApiRequestRouter.getCurrentUser())
    }
    
    public func getProjects() -> Promise<[PSProject]> {
        return doRequest(requestRouter: WalletApiRequestRouter.getProjects())
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
}
