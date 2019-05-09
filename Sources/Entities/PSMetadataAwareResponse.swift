import ObjectMapper

public class PSMetadataAwareResponse<T: Mappable>: Mappable  {
    
    public var items: [T]?
    public var metaData: PSMetadata?
    
    private var itemsResponseKey: String {
        
        switch T.self {
        case ( _) where T.self == PSLocation.self:
            return "locations"
        case ( _) where T.self == PSIdentificationRequest.self:
            return "identification_requests"
            
            
        default:
            return ""
        }
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        items       <- map[itemsResponseKey]
        metaData    <- map["_metadata"]
    }
}
