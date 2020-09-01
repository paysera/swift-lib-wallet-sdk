import ObjectMapper

public class PSGeneratorParameters: Mappable {
    public var secretIterations: Int!
    public var secretLength: Int!
    public var signIterations: Int!
    public var signLength: Int!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        secretIterations    <- map["secret_iterations"]
        secretLength        <- map["secret_length"]
        signIterations      <- map["sign_iterations"]
        signLength          <- map["sign_length"]
    }
}
