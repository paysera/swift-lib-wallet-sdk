import ObjectMapper

public class PSAccountInformation: Mappable {
    public let accountNumber: String
    public var ownerDisplayName: String?
    public var ownerTitle: String?
    public var ownerType: String?
    public var type: String?
    public var userId: Int?
    public var status: String?
    public var ibans: [String]?
    public var flags: PSAccountInformationFlags?
    public var accountDescription: String?
    
    required public init?(map: Map) {
        do {
            accountNumber = try map.value("number")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        ownerDisplayName    <- map["owner_display_name"]
        ownerTitle          <- map["owner_title"]
        ownerType           <- map["owner_type"]
        status              <- map["status"]
        type                <- map["type"]
        userId              <- map["user_id"]
        flags               <- map["flags"]
        accountDescription  <- map["description"]
        ibans               <- map["ibans"]
    }
}
