import ObjectMapper

public final class PSPartnerTokensOAuthRequest: Mappable {
    public var walletID: Int!
    public var partner: String!
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        walletID    <- map["wallet_id"]
        partner     <- map["partner"]
    }
}
