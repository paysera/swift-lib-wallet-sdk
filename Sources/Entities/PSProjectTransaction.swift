import ObjectMapper

public class PSProjectTransaction: Mappable {
    
    public var id: String?
    public var projectId: Int?
    public var locationId: Int?
    public var status: String?
    public var createdAt: TimeInterval?
    private var payments: Array<PSPayment>?
    public var payment: PSPayment?
    
    public init() {}
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        id              <- map["transaction_key"]
        projectId       <- map["project_id"]
        locationId      <- map["location_id"]
        status          <- map["status"]
        createdAt       <- map["created_at"]
        payments        <- map["payments"]
        if let psPayment = payments?.first {
            payment = psPayment
        }
    }
}
