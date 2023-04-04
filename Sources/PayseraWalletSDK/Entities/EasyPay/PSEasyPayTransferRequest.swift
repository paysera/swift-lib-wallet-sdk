import ObjectMapper
import PayseraCommonSDK

public final class PSEasyPayTransferRequest: PSBaseFilter {
    public var amount: PSMoney?
    public var beneficiaryUserID: Int?
    public var payerWalletID: Int?
    
    public init(
        amount: PSMoney?,
        beneficiaryUserID: Int?,
        payerWalletID: Int?
    ) {
        super.init()
        
        self.amount = amount
        self.beneficiaryUserID = beneficiaryUserID
        self.payerWalletID = payerWalletID
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        amount              <- map["amount"]
        beneficiaryUserID   <- map["beneficiary_user_id"]
        payerWalletID       <- map["payer_wallet_id"]
    }
}
