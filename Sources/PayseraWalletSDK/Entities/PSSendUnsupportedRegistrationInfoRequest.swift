import ObjectMapper

public class PSSendUnsupportedRegistrationInfoRequest: Mappable {
    public var id: Int?
    public var email: String!
    public var countryCode: String!
    public var createdAt: Int?
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        id              <- map["id"]
        email           <- map["email"]
        countryCode     <- map["country_code"]
        createdAt       <- map["created_at"]
    }
}
