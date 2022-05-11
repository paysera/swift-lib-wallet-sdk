import ObjectMapper
import PayseraCommonSDK
import Foundation

public final class PSEasyPayTransfer: Mappable {
    public var payerID: Int!
    public var status: PSEasyPayTransferStatus!
    public var beneficiaryUserID: Int!
    public var amount: String!
    public var currency: String!
    public var invoice: String!
    public var revID: String!
    public var transferID: Int!
    public var validUntil: Date!
    
    public var amountMoney: PSMoney {
        .init(amount: amount, currency: currency)
    }
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        payerID             <- map["payer_id"]
        status              <- (map["status"], PSEasyPayTransferStatus.Transform())
        beneficiaryUserID   <- map["beneficiary_user_id"]
        amount              <- map["amount"]
        currency            <- map["currency"]
        invoice             <- map["invoice"]
        revID               <- map["revId"]
        transferID          <- map["transfer_id"]
        validUntil          <- (map["valid_until"], DateTransform())
    }
}

public struct PSEasyPayTransferStatus: RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension PSEasyPayTransferStatus {
    public static let new = PSEasyPayTransferStatus(rawValue: "new")
    public static let created = PSEasyPayTransferStatus(rawValue: "created")
    public static let failed = PSEasyPayTransferStatus(rawValue: "failed")
    public static let cancelled = PSEasyPayTransferStatus(rawValue: "cancelled")
    public static let done = PSEasyPayTransferStatus(rawValue: "done")
    public static let expired = PSEasyPayTransferStatus(rawValue: "expired")
    public static let processingCancellation = PSEasyPayTransferStatus(rawValue: "processing_cancellation")
    public static let deniedCancellation = PSEasyPayTransferStatus(rawValue: "cancellation_denied")
}

extension PSEasyPayTransferStatus {
    class Transform: TransformType {
        func transformFromJSON(_ value: Any?) -> PSEasyPayTransferStatus? {
            guard let value = value as? String else {
                return nil
            }
            return PSEasyPayTransferStatus(rawValue: value)
        }

        func transformToJSON(_ value: PSEasyPayTransferStatus?) -> String? {
            value?.rawValue
        }
    }
}
