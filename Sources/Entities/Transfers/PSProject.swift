import ObjectMapper

public class PSProject: Mappable {
    public let id: Int
    public let title: String
    public var projectDescription: String?
    public var walletId: Int?
    public var wallet: PSWallet?
    
    required public init?(map: Map) {
        do {
            id = try map.value("id")
            title = try map.value("title")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        projectDescription      <- map["description"]
        walletId                <- map["wallet_id"]
        wallet                  <- map["wallet"]
    }
}
