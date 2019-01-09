import ObjectMapper

public class PSBeneficiaryBankAccount: Mappable {
    public var iban: String?
    public var bic: String?
    public var bankTitle: String?
    public var sortCode: String?
    public var accountNumber: String?
    public var countryCode: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        iban            <- map["iban"]
        bic             <- map["bic"]
        bankTitle       <- map["bank_title"]
        sortCode        <- map["sort_code"]
        accountNumber   <- map["account_number"]
        countryCode     <- map["country_code"]
    }
}
