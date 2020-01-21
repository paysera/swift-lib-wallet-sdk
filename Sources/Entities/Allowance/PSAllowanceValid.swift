import ObjectMapper

public class PSAllowanceValid: Mappable {
    public var `for`: Int?
    public var until: Int?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        `for`           <- map["for"]
        until           <- map["until"]
    }
}
