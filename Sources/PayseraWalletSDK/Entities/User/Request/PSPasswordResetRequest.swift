import Foundation
import ObjectMapper

public class PSPasswordResetRequest: Mappable {
    
    public var phone: String?
    public var email: String?
    public var personCode: String?
    
    required public init?(map: Map) {}
    
    public init() {
    }
    
    public func mapping(map: Map) {
        email        <- map["email"]
        phone        <- map["phone"]
        personCode   <- map["identity.code"]
    }
}
