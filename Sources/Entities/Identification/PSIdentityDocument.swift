import ObjectMapper

public class PSIdentityDocument: Mappable {
    
    public var id: Int?
    public var comment: String?
    public var identificationRequestId: Int?
    public var reliability: String?
    public var reviewStatus: String?
    public var reviewedAt: String?
    public var reviewedByUserId: String?
    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    // Mappable
    public func mapping(map: Map) {
        id                          <- map["id"]
        comment                     <- map["comment"]
        identificationRequestId     <- map["identification_request_id"]
        reliability                 <- map["reliability"]
        reviewStatus                <- map["review_status"]
        reviewedAt                  <- map["reviewed_at"]
        reviewedByUserId            <- map["reviewed_by_user_id"]
    }
}
