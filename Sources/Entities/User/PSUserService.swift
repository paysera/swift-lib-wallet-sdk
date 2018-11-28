import ObjectMapper

public class PSUserService: Mappable {
    
    public let name: String
    public let status: String
    public let title: String
    public let actions: [String]
    public var enabledTime: TimeInterval?
    public let url: String
    public let urlPlan: String
    
    required public init?(map: Map) {
        do {
            name = try map.value("service")
            status = try map.value("status")
            title = try map.value("title")
            actions = try map.value("actions")
            url = try map.value("url")
            urlPlan = try map.value("url_plan")
            
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        enabledTime     <- map["added"]
    }
}
