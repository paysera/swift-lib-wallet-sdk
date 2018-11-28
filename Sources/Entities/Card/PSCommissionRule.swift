import ObjectMapper

public class PSCommissionRule: Mappable {
    public var percent: Double?
    public var fix: String?
    public var min: String?
    public var max: String?
    public var currency: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        percent     <- map["percent"]
        fix         <- map["fix"]
        min         <- map["min"]
        max         <- map["max"]
        currency    <- map["currency"]
    }
}
