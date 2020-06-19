import ObjectMapper
import PayseraCommonSDK

public class PSStatement: Mappable {
    
    public var id: Int!
    public var transferId: Int!
    public var accountNumber: String!
    public var amountDecimal: String!
    public var date: Int!
    public var amount: Int!
    public var direction: String!
    public var details: String?
    public var type: String!
    public var currency: String!
    public var otherParty: PSOtherParty?
    
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
    
    public func getAmountMoney() -> PSMoney {
        PSMoney(amount: amountDecimal, currency: currency)
    }
}
