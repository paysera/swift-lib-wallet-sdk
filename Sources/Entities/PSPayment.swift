import ObjectMapper

public class PSPayment: Mappable {
    public var id: Int?
    public var paymentDescription: String?
    public var price: Int?
    public var cashback: Int?
    public var currency: String?
    public var beneficiary: PSWalletIdentifier?
    public var items: [PSPaymentItem]?

    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id                  <- map["id"]
        paymentDescription  <- map["description"]
        beneficiary         <- map["beneficiary"]
        price               <- map["price"]
        cashback            <- map["cashback"]
        currency            <- map["currency"]
        items               <- map["items"]
    }
}
