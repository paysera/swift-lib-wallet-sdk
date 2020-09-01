import PayseraCommonSDK
import ObjectMapper

public class PSTransferFilter: PSBaseFilter {
    public var statuses: [String] = []
    public var creditAccountNumber: String?
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        statuses            <- map["statuses"]
        creditAccountNumber <- map["credit_account_number"]
    }
}
