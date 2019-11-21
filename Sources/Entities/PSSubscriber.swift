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

extension PSSubscriber: Equatable {
    public static func == (lhs: PSSubscriber, rhs: PSSubscriber) -> Bool {
        guard lhs.id == rhs.id,
            lhs.type == rhs.type,
            lhs.recipient == rhs.recipient,
            lhs.locale == rhs.locale,
            lhs.privacyLevel == rhs.privacyLevel,
            lhs.events?.count == rhs.events?.count
        else { return false }
        
        var lEvents = lhs.events ?? []
        var rEvents = rhs.events ?? []
        
        while let lEvent = lEvents.popLast() {
            guard let rIndex = rEvents.firstIndex(of: lEvent) else {
                return false
            }
            rEvents.remove(at: rIndex)
        }
        
        return lEvents.count == rEvents.count
    }
}

extension PSSubscriberRecipient: Equatable {
    public static func == (lhs: PSSubscriberRecipient, rhs: PSSubscriberRecipient) -> Bool {
        return lhs.identifier == rhs.identifier
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
