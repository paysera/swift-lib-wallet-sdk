import Foundation
import ObjectMapper

public final class PSCredentials: Mappable {
    public var accessToken: String?
    public var macKey: String?
    public var refreshToken: String?
    public var macAlgorithm: String?
    public var expiresIn: TimeInterval?
    public var tokenType: String?
    public var validUntil: Date?
    
    required public init?(map: Map) {
        do {
            validUntil = Date().addingTimeInterval(try Double(map.value("expires_in") ?? 0))
        } catch {
            // intentionally not returning nil
        }
    }
    
    public init() {}
    
    // Mappable
    public func mapping(map: Map) {
        tokenType           <- map["token_type"]
        accessToken         <- map["access_token"]
        macAlgorithm        <- map["mac_algorithm"]
        macKey              <- map["mac_key"]
        expiresIn           <- map["expires_in"]
        refreshToken        <- map["refresh_token"]
    }
}
