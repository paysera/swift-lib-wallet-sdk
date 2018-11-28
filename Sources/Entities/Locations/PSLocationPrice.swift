import ObjectMapper

public class PSLocationPrice: Mappable {
    public let type: String
    public let title: String
    public var price: PSMoney?
    
    required public init?(map: Map) {
        do {
            type = try map.value("type")
            title = try map.value("title")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        price           <- map["price"]
    }
}
