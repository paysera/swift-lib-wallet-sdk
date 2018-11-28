import ObjectMapper

public class PSUserLoginRequest: Mappable {
    
    public var username: String?
    public var password: String?
    public var scopes: [String]?
    public var grantType: String?
    
    required public init?(map: Map) {}
    
    public init() {
    }
    
    public func mapping(map: Map) {
        username        <- map["username"]
        password        <- map["password"]
        grantType       <- map["grant_type"]
        
        // it's using only for serialization to JSON
        var scope = self.scopes?.joined(separator: " ")
        scope           <- map["scope"]
    }
}

