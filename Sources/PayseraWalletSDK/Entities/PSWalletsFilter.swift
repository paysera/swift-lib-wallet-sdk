import ObjectMapper
import PayseraCommonSDK

public class PSWalletsFilter: PSBaseFilter {
    public var emailHashes: [String] = []
    public var phoneHashes: [String] = []
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        emailHashes        <- map["email_hash"]
        phoneHashes        <- map["phone_hash"]
    }
    
    public func toJSON() -> [String : Any] {
        var params = super.toJSON()
        
        if !emailHashes.isEmpty {
            params["email_hash"] = emailHashes.joined(separator: ",")
        }
        if !phoneHashes.isEmpty {
            params["phone_hash"] = phoneHashes.joined(separator: ",")
        }
        
        return params
    }
}
