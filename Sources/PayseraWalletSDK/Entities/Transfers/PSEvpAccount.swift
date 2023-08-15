import ObjectMapper

public class PSEvpAccount: Mappable {
    public var accountNumber: String?
    public var error: String?
    public var errorDescription: String?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        accountNumber    <- map["account_number"]
        error            <- map["error"]
        errorDescription <- map["error_description"]
    }
}
