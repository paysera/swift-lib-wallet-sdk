import ObjectMapper

public final class PSCreatePartnerOAuthResponse: Mappable {
    public var key: String!
    public var scopes: [String] = []
    public var walletID: Int!
    public var allowance: PSPartnerOAuthAllowance!
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        key         <- map["key"]
        scopes      <- map["scopes"]
        walletID    <- map["wallet_id"]
        allowance   <- map["allowance"]
    }
}

public final class PSPartnerOAuthAllowance: Mappable {
    public var walletID: Int!
    public var transactionKey: String!
    public var validUntil: String!
    public var maxPrice: String!
    public var currency: String!
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        walletID        <- map["wallet"]
        transactionKey  <- map["transaction_key"]
        validUntil      <- map["valid_until"]
        maxPrice        <- map["max_price"]
        currency        <- map["currency"]
    }
}
