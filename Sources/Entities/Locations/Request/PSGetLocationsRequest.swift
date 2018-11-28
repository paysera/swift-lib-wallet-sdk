import Foundation
import ObjectMapper

public class PSGetLocationsRequest: Mappable {

    public var locale: String?
    public var offset: Int?
    public var limit: Int?
    public var status: String?
    public var updatedAfter: TimeInterval?
    
    public required init?(map: Map) {
    }
    
    public init() {
    }
    
    public func mapping(map: Map) {
        locale          <- map["locale"]
        offset          <- map["offset"]
        limit           <- map["limit"]
        status          <- map["status"]
        updatedAfter    <- map["updated_after"]
    }
}
