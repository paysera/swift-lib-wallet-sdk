import ObjectMapper

public class PSContactCollectionRequest: Mappable {
    public var email: String!
    public var countryCode: String!
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        email           <- map["email"]
        countryCode     <- map["country_code"]
    }
}
