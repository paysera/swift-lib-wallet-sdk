import ObjectMapper

public class PSQRCodeInformation: Mappable  {
    
    public var type: String
    public var parameters: [String: Any]?
    
    required public init?(map: Map) {
        do {
            type = try map.value("type")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        parameters       <- map["parameters"]
    }
}
