import ObjectMapper

public class PSCardAccount: Mappable {
    public var number: String!
    public var order: Int!
    
    public init() {}
    
    required public init?(map: Map) {
        do {
            number = try map.value("number")
            order = try map.value("order")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        number  <- map["number"]
        order   <- map["order"]
    }
}
