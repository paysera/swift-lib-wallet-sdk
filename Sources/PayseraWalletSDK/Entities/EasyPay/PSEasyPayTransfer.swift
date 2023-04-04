import Foundation
import ObjectMapper
import PayseraCommonSDK

public final class PSEasyPayTransfer: Mappable {
    public var id: Int!
    public var payerWalletID: Int!
    public var status: PSEasyPayTransferStatus!
    public var beneficiaryUserID: Int!
    public var amount: PSMoney!
    public var invoice: String!
    public var revID: String!
    public var validUntil: Date!

    required public init?(map: Map) {}

    public func mapping(map: Map) {
        id                  <- map["id"]
        payerWalletID       <- map["payer_wallet_id"]
        status              <- (map["status"], PSEasyPayTransferStatus.Transform())
        beneficiaryUserID   <- map["beneficiary_user_id"]
        amount              <- map["amount"]
        invoice             <- map["invoice"]
        revID               <- map["rev_id"]
        validUntil          <- (map["valid_until"], DateTransform())
    }
}
