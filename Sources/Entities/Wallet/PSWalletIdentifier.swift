import ObjectMapper

public class PSWalletIdentifier: Mappable {
    public var id: Int?
    public var phone: String?
    public var email: String?
    public var wallet: PSWallet?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id              <- map["id"]
        phone           <- map["phone"]
        email           <- map["email"]
        wallet          <- map["wallet"]
    }
}
