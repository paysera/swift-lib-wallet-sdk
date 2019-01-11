import ObjectMapper

public class PSTransfer: Mappable {
    
    public let id: String
    public let status: String
    public let beneficiary: PSBeneficiary
    public var initiator: PSTransferInitiator?
    public let createdAt: TimeInterval
    public let performAt: TimeInterval
    public var failureStatus: PSTransferFailureStatus?
    public var outCommission: PSMoney?
    public var urgency: String?
    public var amount: PSMoney
    public var payer: PSPayer
    public var purpose: PSPurpose?
    public var allowedToCancel: Bool
    public var cancelable: Bool
    public var notifications: [PSTransferNotification]?
    
    required public init?(map: Map) {
        
        do {
            id = try map.value("id")
            status = try map.value("status")
            beneficiary = try map.value("beneficiary")
            createdAt = try map.value("created_at")
            performAt = try map.value("perform_at")
            amount = try map.value("amount")
            payer = try map.value("payer")
            allowedToCancel = try map.value("allowed_to_cancel")
            cancelable = try map.value("cancelable")
        } catch {
            return nil
        }
        notifications = mapEnumeratedJSON(json: map.JSON["notifications"] as? [String: Any], enumeratedElementKey: "status")
    }
    
    public func mapping(map: Map) {
        failureStatus   <- map["failure_status"]
        urgency         <- map["urgency"]
        amount          <- map["amount"]
        initiator       <- map["initiator"]
        outCommission   <- map["out_commission"]
        payer           <- map["payer"]
        purpose         <- map["purpose"]
        allowedToCancel <- map["allowed_to_cancel"]
        cancelable      <- map["cancelable"]
    }
    
    func isSigned() -> Bool {
        return self.status == TransferStatus.signed.description
    }
    
    func isProccesing() -> Bool {
        return self.status == TransferStatus.processing.description
    }
    
    func isReady() -> Bool {
        return self.status == TransferStatus.ready.description
    }
    
    func isReserved() -> Bool {
        return self.status == TransferStatus.reserved.description
    }
}
