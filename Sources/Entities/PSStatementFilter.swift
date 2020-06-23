import PayseraCommonSDK
import ObjectMapper

public class PSStatementFilter: PSBaseFilter {
    
    public var from: Date?
    public var to: Date?
    public var currency: String?
    
    public func toJSON() -> [String : Any] {
        var parameters = super.toJSON()
        if let value = DateTransform().transformToJSON(from) {
            parameters["from"] = Int(value)
        }
        if let value = DateTransform().transformToJSON(to) {
            parameters["to"] = Int(value)
        }
        if let value = currency {
            parameters["currency"] = value
        }
        return parameters
    }
}
