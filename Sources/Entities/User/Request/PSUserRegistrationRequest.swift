import ObjectMapper

public class PSUserRegistrationRequest: Mappable {

    public var phone: String?
    public var locale: String?
    public var password: String?
    public var scopes: [String]?
    public var credentialsType: String?
    
    required public init?(map: Map) {}
    
    public init() {
    }
    
    public func mapping(map: Map) {
        phone           <- map["phone"]
        locale          <- map["locale"]
        password        <- map["credentials.password"]
        credentialsType <- map["credentials.type"]
        scopes          <- map["parameters.scopes"]
    }
}
