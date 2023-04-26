import ObjectMapper

public class PSIdentityDocument: Mappable {
    public var id: Int?
    public var comment: String?
    public var identificationRequestId: Int?
    public var reliability: String?
    public var reviewStatus: String?
    public var reviewedAt: String?
    public var reviewedByUserId: String?
    public var files: Array<PSIdentityFile>?
    public var countryOfIssue: String?
    public var type: String?
    
    required public init?(map: Map) {}
    
    public init() {}
    
    public func mapping(map: Map) {
        id                          <- map["id"]
        comment                     <- map["comment"]
        identificationRequestId     <- map["identification_request_id"]
        reliability                 <- map["reliability"]
        reviewStatus                <- map["review_status"]
        reviewedAt                  <- map["reviewed_at"]
        reviewedByUserId            <- map["reviewed_by_user_id"]
        files                       <- map["files"]
        countryOfIssue              <- map["country_of_issue"]
        type                        <- map["type"]
    }
}

public class PSIdentityFile: Mappable {
    public var id: Int?
    public var type: String?
    public var mimeType: String?
    public var documentID: Int?
    public var documentType: String?
    
    required public init?(map: Map) {}
    
    public init() {}
    
    public func mapping(map: Map) {
        id           <- map["file_id"]
        type         <- map["type"]
        mimeType     <- map["mime_type"]
        documentID   <- map["document_id"]
        documentType <- map["document_type"]
    }
}
