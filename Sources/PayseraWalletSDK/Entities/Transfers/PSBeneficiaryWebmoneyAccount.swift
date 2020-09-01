import ObjectMapper

public class PSBeneficiaryWebmoneyAccount: Mappable {
    public var purse: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        purse <- map["purse"]
    }
}
