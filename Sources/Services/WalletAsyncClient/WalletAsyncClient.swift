import Foundation
import Alamofire
import ObjectMapper
import PromiseKit

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
    
    public func getSpot(byId id: Int) -> Promise<PSSpot> {
        return doRequest(requestRouter: WalletApiRequestRouter.getSpot(id: id))
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
    
    public func getWallet(byId id: Int) -> Promise<PSWallet> {
        return doRequest(requestRouter: WalletApiRequestRouter.getWallet(id: id))
    }
    
    public func getUserWallets(inactiveIncluded: String) -> Promise<[PSWallet]> {
        return doRequest(requestRouter: WalletApiRequestRouter.getUserWallets(inactiveIncluded: inactiveIncluded))
    }
    
    public func getTransfer(byId id: Int) -> Promise<PSTransfer> {
        return doRequest(requestRouter: WalletApiRequestRouter.getTransfer(id: id))
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
    
    public func get(path: String, parameters: [String: Any]? = nil) -> Promise<String> {
        
        let request = createRequest(WalletApiRequestRouter.get(path: path, parameters: parameters))
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
}
