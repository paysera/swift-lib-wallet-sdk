import ObjectMapper

public class PSPasswordChangeRequest: Mappable {
    
    public var code: String?
    public var password: String?
    public var oldPassword: String?
    
    required public init?(map: Map) {}
    
    public init() {
    }
    
    public func mapping(map: Map) {
        code            <- map["code"]
        password        <- map["password"]
        oldPassword     <- map["old_password"]
    }
}
