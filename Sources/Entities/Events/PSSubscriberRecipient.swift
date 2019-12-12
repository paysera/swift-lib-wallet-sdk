import ObjectMapper

public class PSSubscriberRecipient: Mappable {
    public var identifier: String?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        identifier      <- map["identifier"]
    }
}


extension PSSubscriberRecipient: Equatable {
    public static func == (lhs: PSSubscriberRecipient, rhs: PSSubscriberRecipient) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
