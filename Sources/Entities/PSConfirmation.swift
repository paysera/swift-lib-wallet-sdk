import Foundation
import ObjectMapper

public class PSConfirmation: Mappable {
    public var challengeId: String!
    public var identifier: String!
    public var status: String!
    public var properties: PSConfirmationProperties!
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        challengeId <- map["challenge_id"]
        identifier <- map["identifier"]
        status <- map["status"]
        properties <- map["properties"]
    }
}

public class PSConfirmationProperties: Mappable {
    public var slug: String!
    public var code: String!
    public var type: String!
    public var isAcceptanceRequired: Bool!
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        slug <- map["slug"]
        code <- map["code"]
        type <- map["type"]
        isAcceptanceRequired <- map["acceptance_required"]
    }
}
