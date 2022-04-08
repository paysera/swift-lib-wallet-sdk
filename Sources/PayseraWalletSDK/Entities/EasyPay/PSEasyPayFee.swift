import ObjectMapper
import PayseraCommonSDK

public final class PSEasyPayFee: Mappable {
    public var transferAmount: String!
    public var transferCurrency: String!
    public var feeAmount: String!
    public var feeCurrency: String!
    
    public var transferAmountMoney: PSMoney {
        .init(amount: transferAmount, currency: transferCurrency)
    }
    
    public var feeAmountMoney: PSMoney {
        .init(amount: feeAmount, currency: feeCurrency)
    }
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        transferAmount      <- map["transfer_amount"]
        transferCurrency    <- map["transfer_currency"]
        feeAmount           <- map["fee_amount"]
        feeCurrency         <- map["fee_currency"]
    }
}
