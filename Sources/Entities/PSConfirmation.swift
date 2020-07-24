import Foundation
import ObjectMapper
import PayseraCommonSDK

public class PSConfirmation: Mappable {
    public var challengeId: String!
    public var identifier: String!
    public var status: String!
    public var properties: PSConfirmationProperties!
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        challengeId   <- map["challenge_id"]
        identifier    <- map["identifier"]
        status        <- map["status"]
        properties    <- map["properties"]
    }
}

public class PSConfirmationProperties: Mappable {
    public var slug: String!
    public var code: String!
    public var type: String!
    public var isAcceptanceRequired: Bool!
    public var translationParameters: PSConfirmationTranslationParameters?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        slug                  <- map["slug"]
        code                  <- map["code"]
        type                  <- map["type"]
        isAcceptanceRequired  <- map["acceptance_required"]
        translationParameters            <- map["translation_parameters"]
    }
}

public class PSConfirmationTranslationParameters: Mappable {
    public var phone: String?
    public var email: String?
    public var transfersMoneySums: [PSMoney]?
    public var beneficiaryAccount: String?
    public var transfersCount: Int?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        phone                 <- map["%phone%"]
        email                 <- map["%email%"]
        transfersMoneySums     <- map["transfers_money_sums"]
        beneficiaryAccount    <- map["beneficiary_account"]
        transfersCount        <- map["transfers_count"]
    }
}
