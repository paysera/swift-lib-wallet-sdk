import ObjectMapper

public class PSPurpose: Mappable {
    public var details: String?
    public var reference: String?
    public var detailsOptions: PSDetailsOptions?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        details <- map["details"]
        reference <- map["reference"]
        detailsOptions  <- map["details_options"]
    }
}
