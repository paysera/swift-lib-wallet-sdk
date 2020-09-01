import ObjectMapper

public class PSCardRelation: Mappable {
    public var redirectUri: String!
    public var redirectBackUri: String?
    public var locale: String?
    
    public init() {}
    
    required public init?(map: Map) {
        do {
            redirectUri = try map.value("redirect_uri")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        redirectBackUri     <- map["redirect_back_uri"]
        locale              <- map["locale"]
    }
}
