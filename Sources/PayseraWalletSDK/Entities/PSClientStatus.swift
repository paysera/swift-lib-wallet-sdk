import ObjectMapper

public final class PSClientStatus: Mappable {
    public var status: String
    
    required public init?(map: Map) {
        do {
            status = try map.value("status")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        status <- map["status"]
    }
}
