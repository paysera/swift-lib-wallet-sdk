import Foundation
import ObjectMapper

public class PSCard: Mappable {
    public let id: Int
    public let userId: Int
    public let status: String
    public var relation: PSCardRelation?
    public var data: PSCardData?
    public var accounts: Array<PSCardAccount>?
    public var commissionRule: PSCommissionRule?
    public var relatedAt: Date?
    
    
    required public init?(map: Map) {
        do {
            id = try map.value("id")
            userId = try map.value("user_id")
            status = try map.value("status")
            
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
        relatedAt       <- (map["related_at"], DateTransform())
        relation        <- map["relation"]
        data            <- map["card_data"]
        accounts        <- map["accounts"]
        commissionRule  <- map["commission_rule"]
        
    }
}
