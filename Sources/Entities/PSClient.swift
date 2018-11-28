import ObjectMapper

public class PSClient: Mappable {
    
    public var credentials: PSCredentials
    
    required public init?(map: Map) {
        do {
            credentials = try map.value("credentials")
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
    }
}
