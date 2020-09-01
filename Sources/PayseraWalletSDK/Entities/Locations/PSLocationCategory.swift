import ObjectMapper

public class PSLocationCategory: Mappable {
    public let id: Int
    public let title: String
    public var parentId: Int?
    public var images: PSLocationCategoryImages?
    
    required public init?(map: Map) {
        do {
            id = try map.value("id")
            title = try map.value("title")
            
        } catch {
            return nil
        }
    }
    
    // Mappable
    public func mapping(map: Map) {
        parentId        <- map["parent_id"]
        images          <- map["images"]
    }
}
