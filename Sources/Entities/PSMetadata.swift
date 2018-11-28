import ObjectMapper

public class PSMetadata: Mappable {
    public let total: Int
    public let offset: Int
    public let limit: Int
    
    required public init?(map: Map) {
        do {
            total = try map.value("total")
            offset = try map.value("offset")
            limit = try map.value("limit")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
    }
}
