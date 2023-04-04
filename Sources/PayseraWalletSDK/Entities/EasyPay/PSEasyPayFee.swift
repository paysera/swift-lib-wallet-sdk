import ObjectMapper
import PayseraCommonSDK

public final class PSEasyPayFee: Mappable {
    public var transferAmount: PSMoney!
    public var feeAmount: PSMoney!

    required public init?(map: Map) {}

    public func mapping(map: Map) {
        transferAmount      <- map["transfer_amount"]
        feeAmount           <- map["fee_amount"]
    }
}
