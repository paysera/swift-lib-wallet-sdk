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
