import ObjectMapper

class PSDetailsOptions: Mappable {
    public var preserve: Bool?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        preserve   <- map["preserve"]
    }
}
