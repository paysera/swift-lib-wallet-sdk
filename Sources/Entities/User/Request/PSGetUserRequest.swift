import ObjectMapper

public class PSGetUserRequest: Mappable {
    
    public var phone: String?
    public var email: String?
    
    required public init?(map: Map) {}
    
    public init() {
    }
    
    public func mapping(map: Map) {
        email        <- map["email"]
        phone        <- map["phone"]
    }
}
