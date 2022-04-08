import ObjectMapper

public final class PSEasyPayNotificationRequest: Mappable {
    public var encoded: String!
    public var checkSum: String!
    
    required public init?(map: Map) {}
    
    public init() {}
    
    public func mapping(map: Map) {
        encoded     <- map["ENCODED"]
        checkSum    <- map["CHECKSUM"]
    }
}
