import ObjectMapper

public class PSAccountInformationFlags: Mappable {
    public var `public` = false
    public var savings = false
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        `public` <- map["public"]
        savings  <- map["savings"]
    }
}
