import ObjectMapper

public class PSCreateClientInfoRequest: Mappable {
    
    public var title: String?
    public var os: String?
    public var model: String?
    public var deviceId: String?
    
    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    // Mappable
    open func mapping(map: Map) {
        title           <- map["title"]
        os              <- map["os"]
        model           <- map["model"]
        deviceId        <- map["device_id"]
    }
}
