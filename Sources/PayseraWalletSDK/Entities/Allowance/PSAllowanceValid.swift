import ObjectMapper

public class PSAllowanceValid: Mappable {
    public var validFor: Int?
    public var validUntil: Int?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        validFor            <- map["for"]
        validUntil          <- map["until"]
    }
}
