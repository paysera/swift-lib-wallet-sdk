import ObjectMapper

public class PSCardData: Mappable {
    public let number: String
    public let holder: String
    public let type: String
    public var country: String?
    public var expiration: PSCardExpiration?
    
    required public init?(map: Map) {
        do {
            number = try map.value("number")
            holder = try map.value("holder")
            type = try map.value("type")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        country         <- map["country"]
        expiration      <- map["expiration"]
    }
}
