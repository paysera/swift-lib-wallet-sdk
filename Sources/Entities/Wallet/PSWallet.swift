import ObjectMapper

public class PSWallet: Mappable {
    public let id: Int
    public let ownerId: Int
    public let accountInformation: PSAccountInformation
    
    required public init?(map: Map) {
        do {
            id = try map.value("id")
            ownerId = try map.value("owner")
            accountInformation = try map.value("account")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
    }
}
