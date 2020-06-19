import ObjectMapper

public class PSOtherParty: Mappable {
    
    public var displayName: String?
    public var walletId: Int?
    public var accountNumber: String?
    public var userId: Int?
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        displayName <- map["display_name"]
        walletId <- map["wallet_id"]
        accountNumber <- map["account_number"]
        userId <- map["user_id"]
    }
}
