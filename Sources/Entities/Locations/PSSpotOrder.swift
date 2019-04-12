import ObjectMapper

public class PSSpotOrder: Mappable {
    public let orderId: Int
    public let transactionKey: String
    public let status: String
    public var transaction: PSTransaction?
    
    required public init?(map: Map) {
        do {
            orderId = try map.value("id")
            transactionKey = try map.value("transaction_key")
            status = try map.value("status")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        
        if map.mappingType == .toJSON {
            var orderId = self.orderId
            var transactionKey = self.transactionKey
            var status = self.status
            
            orderId             <- map["id"]
            transactionKey      <- map["transaction_key"]
            transaction         <- map["transaction"]
            status              <- map["status"]
        }
    }
}
