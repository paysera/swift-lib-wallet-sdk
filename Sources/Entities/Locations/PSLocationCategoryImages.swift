import ObjectMapper

public class PSLocationCategoryImages: Mappable {
    public let activeUrl: String
    public let inactiveUrl: String

    
    required public init?(map: Map) {
        do {
            activeUrl = try map.value("active_uri")
            inactiveUrl = try map.value("inactive_url")
            
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}
