import ObjectMapper

public class PSOtherParty: Mappable {
    
    public var displayName: String?
    public var walletId: Int?
    public var accountNumber: String?
    public var userId: Int?
    public var code: String?
    public var phone: String?
    public var email: String?
    public var bic: String?
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        displayName     <- map["display_name"]
        walletId        <- map["wallet_id"]
        accountNumber   <- map["account_number"]
        userId          <- map["user_id"]
        code            <- map["code"]
        phone           <- map["phone"]
        email           <- map["email"]
        bic             <- map["bic"]
    }
}
