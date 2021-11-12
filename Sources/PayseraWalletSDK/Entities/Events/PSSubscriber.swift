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

extension PSSubscriber {
    public func copy() -> PSSubscriber? {
        return PSSubscriber(JSON: self.toJSON())
    }
    
    public func getInformationEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.alert.rawValue &&
            $0.object == PSNotificationObjectType.information.rawValue
        }
    }
    
    public func getTransactionRequestCreatedEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.created.rawValue &&
            $0.object == PSNotificationObjectType.transactionRequest.rawValue
        }
    }
    
    public func getTransactionRequestExpiredEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.expired.rawValue &&
            $0.object == PSNotificationObjectType.transactionRequest.rawValue
        }
    }
    
    public func getTransactionRequestCanceledEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.canceled.rawValue &&
            $0.object == PSNotificationObjectType.transactionRequest.rawValue
        }
    }
    
    public func getUserRegisteredEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.registered.rawValue &&
            $0.object == PSNotificationObjectType.user.rawValue
        }
    }
    
    public func getConfirmationEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.created.rawValue &&
            $0.object == PSNotificationObjectType.confirmation.rawValue
        }
    }
    
    public func getWalletEvents() -> [PSSubscriberEvent] {
        guard let events = events else {
            return []
        }
        return events.filter { isWalletObject($0.object) }
    }
    
    
    public func getWalletEvents(for direction: PSWalletEventDirection) -> [PSSubscriberEvent] {
        guard let events = events else {
            return []
        }
        
        return events.filter {
            let isWalletEvent = isWalletObject($0.object)
            let eventDirection = $0.getDirection()
            
            guard eventDirection != .both else { return isWalletEvent }
            return isWalletEvent && (direction == eventDirection)
        }
    }
    
    public func getSuccessfulCardTransactionEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.transactionSuccessful.rawValue &&
            $0.object == PSNotificationObjectType.card.rawValue
        }
    }
    
    public func getIdentityDocumentReviewStatusValidEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.reviewStatusValid.rawValue &&
            $0.object == PSNotificationObjectType.identityDocument.rawValue
        }
    }
    
    public func getIdentityDocumentReviewStatusDeniedEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.reviewStatusDenied.rawValue &&
            $0.object == PSNotificationObjectType.identityDocument.rawValue
        }
    }
    
    public func getRecurrenceTransferDoneEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.done.rawValue &&
            $0.object == PSNotificationObjectType.recurrenceTransfer.rawValue
        }
    }
    
    public func getRecurrenceTransferFailedEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.failed.rawValue &&
            $0.object == PSNotificationObjectType.recurrenceTransfer.rawValue
        }
    }
    
    public func getSavingsAccountPaymentFilledEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.filled.rawValue &&
            $0.object == PSNotificationObjectType.savingsAccountPayment.rawValue
        }
    }
    
    public func getSavingsAccountPaymentWithdrewEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.withdrew.rawValue &&
            $0.object == PSNotificationObjectType.savingsAccountPayment.rawValue
        }
    }
    
    public func getSavingsAccountPaymentAutomatedFillMadeEvent() -> PSSubscriberEvent? {
        guard let events = events else { return nil }
        return events.first {
            $0.event == PSNotificationEventType.automatedFillMade.rawValue &&
            $0.object == PSNotificationObjectType.savingsAccountPayment.rawValue
        }
    }
    
    private func isWalletObject(_ object: String?) -> Bool {
        return object == PSNotificationObjectType.pendingPayment.rawValue ||
               object == PSNotificationObjectType.statement.rawValue
    }
}
