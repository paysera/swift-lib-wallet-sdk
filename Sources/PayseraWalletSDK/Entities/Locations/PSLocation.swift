import Foundation
import Foundation
import ObjectMapper

public class PSLocation: Mappable {
    public let id: Int
    public var projectId: Int?
    public let title: String
    public var updatedAt: TimeInterval?
    public var status: String?
    public var details: String?
    public var address: String?
    public var lat: Double?
    public var lng: Double?
    public var radius: Int?
    public var prices: [PSLocationPrice]?
    public var workingHours: [PSLocationWorkingHours]?
    public var services: [PSLocationService]?
    public var images: PSLocationPinImages?
    public var remoteOrder: PSLocationRemoteOrder?
    
    required public init?(map: Map) {
        do {
            id = try map.value("id")
            title = try map.value("title")
        } catch {
            return nil
        }
        
        workingHours = mapEnumeratedJSON(json: map.JSON["working_hours"] as? [String : Any], enumeratedElementKey: "day")
        services = mapEnumeratedJSON(json: map.JSON["services"] as? [String : Any], enumeratedElementKey: "service_name")
    }

    public func mapping(map: Map) {
        details         <- map["description"]
        address         <- map["address"]
        lat             <- map["lat"]
        lng             <- map["lng"]
        radius          <- map["radius"]
        prices          <- map["prices"]
        remoteOrder     <- map["remote_orders"]
        projectId       <- map["project_id"]
        status          <- map["status"]
        images          <- map["images"]
        updatedAt       <- map["updated_at"]
    }
}
