import ObjectMapper
import Foundation

public class PSUser: Mappable {
    public var id: Int
    public var displayName: String?
    public var identity: PSUserIdentity?
    public var address: PSAddress?
    public var email: String?
    public var phone: String?
    public var calculatedLevel: String?
    public var identificationLevel: String?
    public var defaultCurrency: String?
    public var wallets = [Int]()
    public var dob: String?
    public var deletionRequestAt: String?
    
    required public init?(map: Map) {
        do {
            id = try map.value("id")
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
        print(map.JSON)
        
        id                  <- map["id"]
        displayName         <- map["display_name"]
        identity            <- map["identity"]
        address             <- map["address"]
        email               <- map["email"]
        phone               <- map["phone"]
        calculatedLevel     <- map["calculated_level"]
        identificationLevel <- map["identification_level"]
        defaultCurrency     <- map["options.default_currency"]
        wallets             <- map["wallets"]
        dob                 <- map["dob"]
        deletionRequestAt   <- map["deletion_request_at"]
    }
}
