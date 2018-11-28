import ObjectMapper

public class PSBeneficiaryTaxAccount: Mappable {
    public var identifier: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        identifier <- map["identifier"]
    }
}
