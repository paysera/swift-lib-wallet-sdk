import ObjectMapper

public class PSCardAccount: Mappable {
    public let number: String
    public let order: Int
    
    
    required public init?(map: Map) {
        do {
            number = try map.value("number")
            order = try map.value("order")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
    }
}
