import ObjectMapper

public class PSLocationWorkingHours: Mappable {
    public let day: String
    public let openingTime: String
    public let closingTime: String
    
    required public init?(map: Map) {
        do {
            day = try map.value("day")
            openingTime = try map.value("opening_time")
            closingTime = try map.value("closing_time")
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}
