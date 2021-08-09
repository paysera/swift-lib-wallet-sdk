import ObjectMapper

public class PSGenerateCodeRequestParameters: Mappable {
    public var action: String?
    public var context: PSGenerateCodeRequestContext?
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        action  <- map["action"]
        context <- map["context"]
    }
}

public class PSGenerateCodeRequestContext: Mappable {
    public var os: String?
    public var osVersion: String?
    public var amount: String?
    public var currency: String?
    public var beneficiaryIban: String?

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        os                  <- map["os"]
        osVersion           <- map["os_version"]
        amount              <- map["amount"]
        currency            <- map["currency"]
        beneficiaryIban     <- map["beneficiary_iban"]
    }
}
