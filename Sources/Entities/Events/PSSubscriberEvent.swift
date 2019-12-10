import ObjectMapper

public class PSSubscriberEvent: Mappable {
    public var event: String?
    public var object: String?
    public var parameters: [String : Any]?
    
    public var identifier: NSNumber?
    public var data: [String : Any]?
    
    public init() {}
    
    public init(event: String, object: String, parameters: [String : Any]?) {
        self.event = event
        self.object = object
        self.parameters = parameters
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        identifier  <- map["id"]
        event       <- map["event"]
        object      <- map["object"]
        parameters  <- map["parameters"]
        data        <- map["data"]
    }
}

extension PSSubscriberEvent: Equatable {
    public static func == (lhs: PSSubscriberEvent, rhs: PSSubscriberEvent) -> Bool {
        guard
            lhs.event == rhs.event,
            lhs.object == rhs.object
        else {
            return false
        }
        
        if lhs.parameters == nil && rhs.parameters == nil {
            return true
        }
        
        guard
            let lParameters = lhs.parameters,
            let rParameters = rhs.parameters
        else { return false }
        
        return NSDictionary(dictionary: lParameters).isEqual(to: rParameters)
    }
}

extension PSSubscriberEvent {
    public func getDirection() -> PSWalletEventDirection {
        guard
            let parameters = parameters,
            let directionParameter = parameters["direction"] as? String,
            let eventDirection = PSWalletEventDirection(rawValue: directionParameter)
        else { return .both }
        return eventDirection
    }
}
