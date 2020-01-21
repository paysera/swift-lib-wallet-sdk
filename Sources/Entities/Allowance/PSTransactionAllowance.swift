import ObjectMapper

public class PSTransactionAllowance: Mappable {
    public var id: Int?
    public var data: PSAllowance?
    public var optional: Bool!

    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id          <- map["id"]
        data        <- map["data"]
        optional    <- map["optional"]
    }
}
