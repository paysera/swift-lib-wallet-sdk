import ObjectMapper

public class PSCardAccountRequest: Mappable {
    public var accounts: [PSCardAccount]?
    public var relation: PSCardRelation?
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        accounts    <- map["accounts"]
        relation    <- map["relation"]
    }
}
