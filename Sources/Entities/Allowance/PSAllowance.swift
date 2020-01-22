import ObjectMapper

public class PSAllowance: Mappable {
    public var description: String?
    public var currency: String!
    public var maxPrice: Int?
    public var valid: PSAllowanceValid?
    public var limits: [PSAllowanceLimit]?

    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        description     <- map["description"]
        currency        <- map["currency"]
        maxPrice        <- map["max_price"]
        valid           <- map["valid"]
        limits          <- map["limits"]
    }
}
