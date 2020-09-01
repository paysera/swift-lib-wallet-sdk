import ObjectMapper

public class PSRefreshTokenRequest: Mappable {
    public var grantType: String?
    public var refreshToken: String?
    public var scopes: [String]?
    public var code: String?
    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    public func mapping(map: Map) {
        
        grantType           <- map["grant_type"]
        refreshToken        <- map["refresh_token"]
        code                <- map["code"]
        
        // it's using only for serialization to JSON
        var scope = self.scopes?.joined(separator: " ")
        scope               <- map["scope"]
    }
}
