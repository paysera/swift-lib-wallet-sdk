import Foundation
import ObjectMapper

public class PSCurrencyConversionResponse: Mappable {
    public var id: Int!
    public var date: Date!
    public var fromCurrency: String!
    public var toCurrency: String!
    public var fromAmountDecimal: String!
    public var toAmountDecimal: String!
    public var accountNumber: String!
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        id                  <- map["id"]
        date                <- (map["date"], DateTransform())
        fromCurrency        <- map["from_currency"]
        toCurrency          <- map["to_currency"]
        fromAmountDecimal   <- map["from_amount_decimal"]
        toAmountDecimal     <- map["to_amount_decimal"]
        accountNumber       <- map["account_number"]
    }
}
