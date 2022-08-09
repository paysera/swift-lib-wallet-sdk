import ObjectMapper

public final class PSPartnerTokensResponse: Mappable {
    public var userID: Int!
    public var authToken: String!
    public var authTokenExpiresIn: Int!
    public var refreshToken: String!
    public var refreshTokenExpiresIn: Int!
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        userID                  <- map["user_id"]
        authToken               <- map["auth_token"]
        authTokenExpiresIn      <- map["auth_token_expires_in"]
        refreshToken            <- map["refresh_token"]
        refreshTokenExpiresIn   <- map["refresh_token_expires_in"]
    }
}
