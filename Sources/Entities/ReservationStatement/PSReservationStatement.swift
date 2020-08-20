import ObjectMapper

public class PSReservationStatement: Mappable {
    public var type: String!
    public var amountDecimal: String!
    public var currency: String!
    public var details: String?
    public var referenceNumber: String?
    public var date: Date!
    public var otherParty: PSOtherParty?
    public var transferId: Int?
    

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        type                <- map["type"]
        amountDecimal       <- map["amount_decimal"]
        currency            <- map["currency"]
        details             <- map["details"]
        referenceNumber     <- map["reference_number"]
        date                <- (map["date"], DateTransform())
        otherParty          <- map["other_party"]
        transferId          <- map["transfer_id"]
    }
}

