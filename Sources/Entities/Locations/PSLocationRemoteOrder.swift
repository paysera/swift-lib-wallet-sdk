import ObjectMapper

public class PSLocationRemoteOrder: Mappable {
    public let spotId: Int
    
    required public init?(map: Map) {
        do {
            spotId = try map.value("spot_id")
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}
