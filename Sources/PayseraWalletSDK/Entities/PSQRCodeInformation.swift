import ObjectMapper

public class PSCodeInformation: Mappable {
    public var type: String
    public var parameters: [String: Any]
    
    required public init?(map: Map) {
        do {
            type = try map.value("type")
            parameters = try map.value("parameters")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) { }
}

public class PSCodeTransaction: Mappable {
    public var transactionKey: String
    
    required public init?(map: Map) {
        do {
            transactionKey = try map.value("transaction_key")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) { }
}

public class PSCodeSpot: Mappable {
    public var spotId: Int
    
    required public init?(map: Map) {
        do {
            spotId = try map.value("spot_id")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) { }
}

public class PSCodePrefill: Mappable {
    public var beneficiary: PSCodePrefillBeneficiary
    public var price: Int?
    public var currency: String?
    public var description: String?
    
    required public init?(map: Map) {
        do {
            guard let beneficiary =  Mapper<PSCodePrefillBeneficiary>().map(JSONObject: try map.value("beneficiary")) else {
                return nil
            }
            
            self.beneficiary = beneficiary
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        price           <- map["price"]
        currency        <- map["currency"]
        description     <- map["description"]
    }
}

public class PSCodePrefillBeneficiary: Mappable {
    public var walletId: Int
    public var accountNumber: String
    public var userId: Int
    public var displayName: String?
    public var phone: String?
    public var email: String?
    
    required public init?(map: Map) {
        do {
            walletId = try map.value("wallet_id")
            accountNumber = try map.value("account_number")
            userId = try map.value("user_id")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        displayName     <- map["display_name"]
        phone           <- map["phone"]
        email           <- map["email"]
    }
}
