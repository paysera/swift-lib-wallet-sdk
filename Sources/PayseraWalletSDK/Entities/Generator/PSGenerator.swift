import ObjectMapper

public class PSGenerator: Mappable {
    public var id: Int!
    public var status: String!
    public var expiresIn: Int!
    public var identifiers: [PSGeneratorIdentifier]!
    public var seed: String?
    public var type: String?
    public var parameters: PSGeneratorParameters?

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        id              <- map["id"]
        status          <- map["status"]
        expiresIn       <- map["expires_in"]
        identifiers     <- map["identifiers"]
        seed            <- map["seed"]
        type            <- map["type"]
        parameters      <- map["params"]
    }
}
