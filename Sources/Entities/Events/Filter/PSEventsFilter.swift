import ObjectMapper

public class PSEventsFilter: Mappable {

    public var from: Int?
    public var limit: Int?
    
    required public init?(map: Map) {}
    
    public init() {}
    
    public func mapping(map: Map) {
        from    <- map["from"]
        limit   <- map["limit"]
    }
}
