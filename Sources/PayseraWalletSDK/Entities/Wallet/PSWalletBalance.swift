import ObjectMapper

public class PSWalletBalance: Mappable {
    public let atDisposal: Int
    public let reserved: Int
    
    required public init?(map: Map) {
        do {
            atDisposal = try map.value("at_disposal")
            reserved = try map.value("reserved")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
    }
}
