import ObjectMapper

public class PSTransactionAllowance: Mappable {
    public var id: Int?
    public var data: PSAllowance?
    public var isOptional: Bool!

    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id              <- map["id"]
        data            <- map["data"]
        isOptional      <- map["optional"]
    }
}
