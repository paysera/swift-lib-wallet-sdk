import ObjectMapper

public class PSIdentificationRequestsFilter: BaseFilter {
 
    public var statuses: [String]?

    public override func mapping(map: Map) {
        super.mapping(map: map)
        statuses        <- map["statuses"]
    }
}
