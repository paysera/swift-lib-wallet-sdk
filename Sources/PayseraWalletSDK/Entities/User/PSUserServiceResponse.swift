import ObjectMapper

public class PSUserServiceResponse: Mappable {
    public var services: [PSUserService] = []
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        services         <- map["services"]
    }
    
    public func isPayseraAppAgreementEnabled() -> Bool {
        return services.first { $0.name == "paysera_app" && $0.status == "enabled" } != nil
    }
}
