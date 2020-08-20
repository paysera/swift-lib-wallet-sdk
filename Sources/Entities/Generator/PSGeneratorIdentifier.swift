import ObjectMapper

public class PSGeneratorIdentifier: Mappable {
    public var identifier: Int!
    public var walletId: Int!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        identifier  <- map["identifier"]
        walletId    <- map["wallet_id"]
    }
}
