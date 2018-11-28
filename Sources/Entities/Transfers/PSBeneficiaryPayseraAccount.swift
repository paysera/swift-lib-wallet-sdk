import ObjectMapper

public class PSBeneficiaryPayseraAccount: Mappable {
    public var phone: String?
    public var email: String?
    public var accountNumber: String?
    public var userId: Int
    
    required public init?(map: Map) {
        do {
            userId = try map.value("user_id")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        userId          <- map["user_id"]
        phone           <- map["phone"]
        email           <- map["email"]
        accountNumber   <- map["account_number"]
    }
}
