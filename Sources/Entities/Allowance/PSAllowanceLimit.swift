import ObjectMapper

public class PSAllowanceLimit: Mappable {
    public var maxPrice: Int!
    public var time: Int?
    public var period: Int?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        maxPrice        <- map["max_price"]
        time            <- map["time"]
        period          <- map["period"]
    }
}
