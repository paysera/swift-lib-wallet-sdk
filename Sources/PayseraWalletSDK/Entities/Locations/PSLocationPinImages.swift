import ObjectMapper

public class PSLocationPinImages: Mappable {
    public let pinOpen: String
    public let pinClosed: String
    
    required public init?(map: Map) {
        do {
            pinOpen = try map.value("pin_open")
            pinClosed = try map.value("pin_closed")
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}
