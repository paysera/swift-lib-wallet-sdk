import Foundation
import ObjectMapper

public class PSServerInformation: Mappable {
    
    public let serverTime: TimeInterval
    public let timeDiff: TimeInterval
    
    required public init?(map: Map) {
        do {
            serverTime = try map.value("time")
            timeDiff = serverTime - Date().timeIntervalSince1970
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {}
}
