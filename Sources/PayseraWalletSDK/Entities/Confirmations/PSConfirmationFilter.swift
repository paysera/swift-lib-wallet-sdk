import ObjectMapper
import PayseraCommonSDK

public class PSConfirmationFilter: PSBaseFilter {
    public var status: String?

    public override func mapping(map: Map) {
        super.mapping(map: map)
        status  <- map["status"]
    }
}
