import ObjectMapper

public class PSContactBookResponse: Mappable {
    public var id: Int!
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        id <- map["id"]
    }
}

