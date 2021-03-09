import ObjectMapper

public class PSGetWalletsResponse: Mappable {
    public var result = [String: PSWallet]()
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {        
        for (key, value) in map.JSON {
            if let walletData = value as? [String: Any] {
                result[key] = Mapper<PSWallet>().map(JSON: walletData)
            }
        }
    }
}
