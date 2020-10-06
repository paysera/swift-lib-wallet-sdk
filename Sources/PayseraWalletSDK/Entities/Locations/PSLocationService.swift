import ObjectMapper

public class PSLocationService: Mappable {
    public let name: String
    public let available: Bool
    public var categories: [Int]?
    public var types: [String] = []
    
    required public init?(map: Map) {
        do {
            name = try map.value("service_name")
            available = try map.value("available")
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
        categories  <- map["categories"]
        types       <- map["types"]
    }
}
