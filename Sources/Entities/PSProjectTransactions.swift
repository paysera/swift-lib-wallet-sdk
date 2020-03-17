import ObjectMapper

public class PSProjectTransactionList: Mappable {
    
    public var transactions: [PSProjectTransaction]?
    
    public init() {}
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        transactions     <- map["transactions"]
    }
}
