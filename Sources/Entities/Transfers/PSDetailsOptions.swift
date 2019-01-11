import ObjectMapper

public class PSDetailsOptions: Mappable {
    public var preserve: Bool?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        preserve   <- map["preserve"]
    }
}
