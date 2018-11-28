import ObjectMapper

public class PSBeneficiaryBankAccount: Mappable {
    public var iban: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        iban <- map["iban"]
    }
}
