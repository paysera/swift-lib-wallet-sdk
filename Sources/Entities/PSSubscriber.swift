import UIKit
import ObjectMapper

public class PSSubscriber: Mappable {
    public var id: Int?
    public var type: String?
    public var recipient: PSSubscriberRecipient?
    public var events: [PSSubscriberEvent]?
    public var locale: String?
    public var privacyLevel: String?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id              <- map["id"]
        type            <- map["type"]
        recipient       <- map["recipient"]
        events          <- map["events"]
        locale          <- map["locale"]
        privacyLevel    <- map["privacy_level"]
    }
}

public class PSSubscriberRecipient: Mappable {
    public var identifier: String?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        identifier      <- map["identifier"]
    }
}

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
