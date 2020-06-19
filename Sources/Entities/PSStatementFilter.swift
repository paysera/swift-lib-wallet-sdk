import PayseraCommonSDK
import ObjectMapper

public class PSStatementFilter: PSBaseFilter {
    
    public let walletId: Int
    public let fromDate: Int
    public let toDate: Int
    
    public init(
        walletId: Int,
        fromDate: Int,
        toDate: Int,
        limit: Int
    ) {
        self.walletId = walletId
        self.fromDate = fromDate
        self.toDate = toDate
        super.init()
        self.limit = limit
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    public func toJSON() -> [String : Any] {
        var parameters = super.toJSON()
        parameters["from"] = fromDate
        parameters["to"] = toDate
        return parameters
    }
}
