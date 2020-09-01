import ObjectMapper

public class PSUserIdentity: Mappable {
    
    public let name: String
    public let surname: String
    public var code: String?
    public var nationality: String?
    
    required public init?(map: Map) {
        do {
            name = try map.value("name")
            surname = try map.value("surname")
            
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
        code            <- map["code"]
        nationality     <- map["nationality"]
    }
}
