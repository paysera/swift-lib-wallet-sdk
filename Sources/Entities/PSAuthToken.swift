import Foundation
import ObjectMapper

public class PSAuthToken: Mappable {
    public var value: String!
    public var userId: Int!
    public var sessionId: String!
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        value <- map["value"]
        userId <- map["user_id"]
        sessionId <- map["session_id"]
    }
}
