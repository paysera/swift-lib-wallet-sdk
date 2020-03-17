import ObjectMapper

public class PSProjectTransactionRequest: Mappable {
    
    public var amount: String?
    public var currency: String?
    public var description: String?
    public var projectId: Int?
    public var locationId: Int?
    
    required public init?(map: Map) { }
    
    public init() {}
    
    public func mapping(map: Map) {
        amount          <- map["amount"]
        currency        <- map["currency"]
        description     <- map["description"]
        projectId       <- map["project_id"]
        projectId       <- map["project_id"]
    }
}
