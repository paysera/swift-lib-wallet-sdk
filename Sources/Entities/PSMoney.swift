import ObjectMapper

public class PSMoney: Mappable {
    
    public let amount: String
    public let currency: String
    
    required public init?(map: Map) {
        do {
            amount = try map.value("amount")
            currency = try map.value("currency")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
    }
}
