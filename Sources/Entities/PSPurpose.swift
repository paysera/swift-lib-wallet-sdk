import ObjectMapper

public class PSPurpose: Mappable {
    public var details: String?
    public var reference: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        details <- map["details"]
        reference <- map["reference"]
    }
}
