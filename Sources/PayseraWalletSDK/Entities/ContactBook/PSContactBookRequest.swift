import ObjectMapper

public class PSContactBookRequest: Mappable {
    public var emails: [String]?
    public var phones: [String]?
    public var emailHashes: [String]?
    public var phoneHashes: [String]?
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        emails          <- map["emails"]
        phones          <- map["phones"]
        emailHashes     <- map["email_hashes"]
        phoneHashes     <- map["phone_hashes"]
    }
}

