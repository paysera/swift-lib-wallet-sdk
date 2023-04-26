import ObjectMapper

public class PSLivenessCheck: Mappable {
    public var id: Int?
    public var identificationRequestID: Int?
    public var livelinessScroe: Int?
    public var identomatSessionID: String?
    
    required public init?(map: Map) {}
    
    public init() {}
        
    public func mapping(map: Map) {
        id                      <- map["id"]
        identificationRequestID <- map["identification_request_id"]
        livelinessScroe         <- map["liveliness_score"]
        identomatSessionID      <- map["identomat_session_id"]
    }
}
