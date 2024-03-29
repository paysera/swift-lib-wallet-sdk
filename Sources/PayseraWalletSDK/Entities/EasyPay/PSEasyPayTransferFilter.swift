import ObjectMapper
import PayseraCommonSDK

public final class PSEasyPayTransferFilter: PSBaseFilter {
    public var status: PSEasyPayTransferStatus?
    public var beneficiaryUserID: Int?
    public var payerWalletID: Int?
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        status              <- (map["status"], PSEasyPayTransferStatus.Transform())
        beneficiaryUserID   <- map["beneficiary_user_id"]
        payerWalletID       <- map["payer_wallet_id"]
    }
}
