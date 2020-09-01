import ObjectMapper

public class PSFirebaseTokenResponse: Mappable {
    public var token: String!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        token <- map["token"]
    }
}

