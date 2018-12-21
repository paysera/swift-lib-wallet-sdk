import ObjectMapper

public class PSWalletApiError: Mappable, Error {
    public var error: String
    public var errorDescription: String?
    public var statusCode: Int?
    
    init(error: String, description: String? = nil) {
        self.error = error
        self.errorDescription = description
    }
    
    required public init?(map: Map) {
        do {
            error = try map.value("error")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        error             <- map["error"]
        errorDescription  <- map["error_description"]
    }
    
    func isRefreshTokenExpired() -> Bool {
        return error == "invalid_grant" && errorDescription == "Refresh token expired"
    }
    
    func isTokenExpired() -> Bool {
        return error == "invalid_grant" && errorDescription == "Token has expired"
    }
    
    func isInvalidTimestamp() -> Bool {
        return error == "invalid_timestamp"
    }
    
    public class func mapping() -> PSWalletApiError {
        return PSWalletApiError.init(error: "mapping", description: "mapping failed")
    }

    public class func cancelled() -> PSWalletApiError {
        return PSWalletApiError(error: "cancelled")
    }
}
