import Foundation
import ObjectMapper

public class PSGeneratorResponse: Mappable {
    public var validUntil: Date!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        validUntil  <- (map["valid_until"], DateTransform())
    }
}

