import ObjectMapper

public class PSServerConfiguration: Mappable {
    public var minimumPasswordLength: Int
    
    required public init?(map: Map) {
        do {
            minimumPasswordLength = try map.value("minimum_password_length")
        } catch {
            return nil
        }
    }
    
    public init(minimumPasswordLength: Int) {
        self.minimumPasswordLength = minimumPasswordLength
    }
    
    public func mapping(map: Map) {
        minimumPasswordLength <- map["minimum_password_length"]
    }
}
