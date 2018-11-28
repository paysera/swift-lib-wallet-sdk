import ObjectMapper

public class PSUserRegistrationRequest: Mappable {

    public var phone: String?
    public var password: String?
    public var locale: String?
    public var scopes: [String]?
    public var credentialsType: String?
    
    required public init?(map: Map) {}

    init(phone: String,
         password: String,
         locale: String,
         scopes: [String] = ["generator_phone_code", "convert_currency_phone_code", "make_bank_payments_phone_code"],
         credentialsType: String = "main-password") {
        
        self.phone = phone
        self.password = password
        self.locale = locale
        self.scopes = scopes
    }
    
    public func mapping(map: Map) {
        phone           <- map["phone"]
        locale          <- map["locale"]
        password        <- map["credentials.password"]
        credentialsType <- map["credentials.type"]
        scopes          <- map["parameters.scopes"]
    }
}
