import ObjectMapper

public class PSCreateClientInfoRequest: Mappable {
    
    public var title: String?
    public var os: String?
    public var model: String?
    public var deviceId: String?
    public var rooted: Bool?
    public var simulator: Bool?
    public var ipIpv4: String?
    public var ipIpv6: String?
    public var wifiSsid: String?
    public var systemLanguage: String?
    public var simCountry: String?
    public var simCarrier: String?
    public var webviewUserAgent: String?
    public var deviceHash: String?
    
    required public init?(map: Map) {
    }
    
    public init() {
    }
    
    // Mappable
    open func mapping(map: Map) {
        title             <- map["title"]
        os                <- map["os"]
        model             <- map["model"]
        deviceId          <- map["device_id"]
        rooted            <- map["rooted"]
        simulator         <- map["simulator"]
        ipIpv4            <- map["ip_ipv4"]
        ipIpv6            <- map["ip_ipv6"]
        wifiSsid          <- map["wifi_ssid"]
        systemLanguage    <- map["system_language"]
        simCountry        <- map["sim_country"]
        simCarrier        <- map["sim_carrier"]
        webviewUserAgent  <- map["webview_user_agent"]
        deviceHash        <- map["device_hash"]
    }
}
