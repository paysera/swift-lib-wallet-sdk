import ObjectMapper

public class PSIdentificationRequest: Mappable {
    public var id: Int?
    public var facePhotos: Array<AnyObject>?
    public var facePhotoDocument: PSFacePhotoDocument?
    public var identityDocuments: Array<PSIdentityDocument>?
    public var userId: String?
    public var status: String?
    public var comment: String?
    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    // Mappable
    public func mapping(map: Map) {
        id                  <- map["id"]
        facePhotos          <- map["face_photos"]
        facePhotoDocument   <- map["face_photo_document"]
        identityDocuments   <- map["identity_documents"]
        userId              <- map["user_id"]
        status              <- map["status"]
        comment             <- map["comment"]
    }
}
