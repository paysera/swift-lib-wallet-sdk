import ObjectMapper

public class PSTransactionRequest: Mappable {
    public var userId: Int?
    public var email: String?
    public var phone: String?
    public var initiatorId: Int?       //ID of the user that initiated this request
    
    required public init?(map: Map) {
    }
    
    public init() {}
    
    public func mapping(map: Map) {
        userId          <- map["user_id"]
        email           <- map["email"]
        phone           <- map["phone"]
        initiatorId     <- map["initiator_id"]
    }
}
