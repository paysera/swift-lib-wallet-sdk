import Foundation
import ObjectMapper

public class PSAuthToken: Mappable {
    public var value: String!
    public var userId: String!
    public var impersonatorId: String?
    public var sessionId: String!
    public var lifetime: Int!
    public var createdAt: Date!
    public var usedAt: Date!
    public var type: String!
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        value <- map["value"]
        userId <- map["user_id"]
        impersonatorId <- map["impersonator_id"]
        sessionId <- map["session_id"]
        lifetime <- map["lifetime"]
        createdAt <- (map["created_at"], DateTransform())
        usedAt <- (map["used_at"], DateTransform())
        type <- map["type"]
    }
}
