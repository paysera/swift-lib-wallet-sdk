import ObjectMapper
import PayseraCommonSDK

public class PSIdentificationRequestsFilter: PSBaseFilter {
    public var statuses: [String]?

    public override func mapping(map: Map) {
        super.mapping(map: map)
        statuses        <- map["statuses"]
    }
}
