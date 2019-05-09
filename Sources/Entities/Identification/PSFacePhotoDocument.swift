import ObjectMapper

public class PSFacePhotoDocument: Mappable {
    
    public var id: Int?
    public var comment: String?
    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    // Mappable
    public func mapping(map: Map) {
        id                          <- map["id"]
        comment                     <- map["comment"]
    }
}
