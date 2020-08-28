import ObjectMapper

public class PSUserPosition: Mappable {
    public var latitude: Float!
    public var longitude: Float!
    public var type: String?

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        latitude    <- map["lat"]
        longitude   <- map["lng"]
        type        <- map["type"]
    }
}

