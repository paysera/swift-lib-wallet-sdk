import Foundation
import ObjectMapper

public class PSTransaction: Mappable {
    public var autoConfirm: Bool?
    public var useAllowance: Bool?
    public var payments: Array<PSPayment>?
    public var allowance: PSTransactionAllowance?
    public var key: String!
    public var status: String!
    public var project: PSProject?
    public var redirectUri: String?
    public var validForPaymentCardDebit: Bool!
    public var projectId: Int?
    public var locationId: Int?
    public var createdAt: TimeInterval?

    
    public init() {}
    
    required public init?(map: Map) { }
    
    // Mappable
    public func mapping(map: Map) {
        autoConfirm                 <- map["auto_confirm"]
        useAllowance                <- map["use_allowance"]
        payments                    <- map["payments"]
        allowance                   <- map["allowance"]
        key                         <- map["transaction_key"]
        status                      <- map["status"]
        project                     <- map["project"]
        redirectUri                 <- map["redirect_uri"]
        validForPaymentCardDebit    <- map["valid_for_payment_card_debit"]
        projectId                   <- map["project_id"]
        locationId                  <- map["location_id"]
        createdAt                   <- map["created_at"]
    }
}
