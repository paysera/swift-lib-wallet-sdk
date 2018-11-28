import ObjectMapper

public class PSCardExpiration: Mappable {
    public var year: Int?
    public var month: Int?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        year    <- map["year"]
        month   <- map["month"]
    }
}
