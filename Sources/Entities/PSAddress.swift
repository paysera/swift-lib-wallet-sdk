import ObjectMapper

public class PSAddress: Mappable {
    
    public let city: String
    public let country: String
    public let street: String
    public var postIndex: String?
    
    
    required public init?(map: Map) {
        do {
            city = try map.value("city")
            country = try map.value("country")
            street = try map.value("street")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        postIndex       <- map["post_index"]
    }
}
