import ObjectMapper

public class PSSpot: Mappable {
    public let id: Int
    public let status: String
    public let identifier: String
    public var place: PSSpotPlace!
    public var orders: [PSSpotOrder]?
    
    required public init?(map: Map) {
        do {
            id = try map.value("id")
            status = try map.value("status")
            identifier = try map.value("identifier")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        if map.mappingType == .toJSON {
            var id = self.id
            var status = self.status
            var identifier = self.identifier
            
            id              <- map["id"]
            status          <- map["status"]
            identifier      <- map["identifier"]
        }
        
        place        <- map["place_info"]
        orders       <- map["orders"]
    }
    
    public func getPendingOrders() -> [PSSpotOrder]? {
        return orders?.filter { $0.status == "pending" }
    }
}
