import ObjectMapper

public class PSSpotPlace: Mappable {
    public var title: String!
    public var spotDescription: String?
    public var address: String?
    public var logoUri: String?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        title           <- map["title"]
        spotDescription <- map["description"]
        address         <- map["address"]
        logoUri         <- map["logo_uri"]
    }
}
