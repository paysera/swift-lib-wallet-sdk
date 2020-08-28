import ObjectMapper

public class PSPendingPayment: Mappable {
    public var id: Int!
    public var amountDecimal: String!
    public var currency: String!
    public var details: String!
    public var direction: String!
    public var type: String!
    public var cancelable: Bool!
    public var validUntil: Int?
    public var password: String?
    public var transferId: Int?
    public var transactionKey: String?
    public var date: Date?
    public var otherParty: PSOtherParty?

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        id                  <- map["id"]
        amountDecimal       <- map["amount_decimal"]
        currency            <- map["currency"]
        details             <- map["details"]
        direction           <- map["direction"]
        type                <- map["type"]
        cancelable          <- map["cancelable"]
        validUntil          <- map["valid_until"]
        password            <- map["password"]
        transferId          <- map["transfer_id"]
        transactionKey      <- map["transaction_key"]
        date                <- (map["date"], DateTransform())
        otherParty          <- map["other_party"]
    }
}

