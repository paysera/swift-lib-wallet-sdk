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
    public var validUntil: Int!
    public var maxPriceDecimal: String!
    public var currency: String!
    public var status: String!
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        walletID        <- map["wallet"]
        transactionKey  <- map["transaction_key"]
        validUntil      <- map["valid_until"]
        maxPriceDecimal <- map["max_price_decimal"]
        currency        <- map["currency"]
        status          <- map["status"]
    }
}
