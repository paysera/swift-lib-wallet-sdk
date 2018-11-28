import ObjectMapper

public class PSAccountInformation: Mappable {
    public let accountNumber: String
    public var ownerDisplayName: String?
    public var ownerTitle: String?
    public var ownerType: String?
    public var accountDescription: String?
    public var userId: Int?
    public var type: String?
    public var ibans: [String]?
    
    required public init?(map: Map) {
        do {
            accountNumber = try map.value("number")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        ownerDisplayName            <- map["owner_display_name"]
        ownerTitle                  <- map["owner_title"]
        ownerType                   <- map["owner_type"]
        accountDescription          <- map["description"]
        userId                      <- map["user_id"]
        type                        <- map["type"]
        ibans                       <- map["ibans"]
    }
}
