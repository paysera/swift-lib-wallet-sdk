import Foundation
import ObjectMapper

public class PSUserService: Mappable {
    public let name: String
    public let status: String
    public let title: String
    public let actions: [String]
    public var enabledTime: TimeInterval?
    public var url: String?
    
    required public init?(map: Map) {
        do {
            name = try map.value("service")
            status = try map.value("status")
            url = try? map.value("url")
            title = try map.value("title")
            actions = try map.value("actions")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        enabledTime     <- map["added"]
    }
}
