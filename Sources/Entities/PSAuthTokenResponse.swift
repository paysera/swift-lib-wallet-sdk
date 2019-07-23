import Foundation
import ObjectMapper

public class PSAuthTokenResponse: Mappable {
    public var type: String!
    public var authToken: PSAuthToken!
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        authToken <- map["auth_token"]
        type      <- map["type"]
    }
}
