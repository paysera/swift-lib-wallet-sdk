import Foundation
import Foundation
import ObjectMapper

public class PSIdentificationDocumentRequest: Mappable {
    public var id: Int?
    public var type: String?
    public var personalNumber: String?
    public var country: String?
    public var dateOfBirth: String?   
    public var firstName: String?
    public var lastName: String?
    public var images: Array<Data>?
    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    // Mappable
    public func mapping(map: Map) {
        id              <- map["id"]
        type            <- map["type"]
        personalNumber  <- map["personal_number"]
        country         <- map["country"]
        dateOfBirth     <- map["date_of_birth"]
        firstName       <- map["first_name"]
        lastName        <- map["last_name"]
        images          <- map["images"]
    }
}
