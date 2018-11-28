import ObjectMapper

public class PSCreateClientRequest: Mappable {
    
    public var type: String?
    public var info: PSCreateClientInfoRequest?

    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    // Mappable
    open func mapping(map: Map) {
        type            <- map["type"]
        info            <- map["info"]
    }
}
