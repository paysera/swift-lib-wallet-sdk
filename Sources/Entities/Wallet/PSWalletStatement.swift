import ObjectMapper

public class PSWalletStatement: Mappable {
    
    public var id: Int!
    public var transferId: Int!
    public var accountNumber: String!
    public var amountDecimal: String!
    public var date: Int!
    public var amount: Double!
    public var direction: String!
    public var details: String?
    public var type: String!
    public var currency: String!
    public var otherParty: PSWalletStatementOtherParty!
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        id <- map["id"]
        transferId <- map["transfer_id"]
        accountNumber <- map["account_number"]
        amountDecimal <- map["amount_decimal"]
        date <- map["date"]
        amount <- map["amount"]
        direction <- map["direction"]
        details <- map["details"]
        type <- map["type"]
        currency <- map["currency"]
        otherParty <- map["other_party"]
    }
}

public class PSWalletStatementOtherParty: Mappable {
    
    public var displayName: String!
    public var walletId: Int!
    public var accountNumber: String!
    public var userId: Int!
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        displayName <- map["display_name"]
        walletId <- map["wallet_id"]
        accountNumber <- map["account_number"]
        userId <- map["user_id"]
    }
}
