import ObjectMapper

public class PSBeneficiary: Mappable {
    public let name: String
    public let type: String
    public var beneficiaryPayseraAccount: PSBeneficiaryPayseraAccount?
    public var beneficiaryBankAccount: PSBeneficiaryBankAccount?
    public var beneficiaryTaxAccount: PSBeneficiaryTaxAccount?
    public var beneficiaryWebmoneyAccount: PSBeneficiaryWebmoneyAccount?
    
    required public init?(map: Map) {
        do {
            name = try map.value("name")
            type = try map.value("type")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        beneficiaryPayseraAccount   <- map["paysera_account"]
        beneficiaryBankAccount      <- map["bank_account"]
        beneficiaryTaxAccount       <- map["tax_account"]
        beneficiaryWebmoneyAccount  <- map["webmoney_account"]
    }
    
    public func isBankAccount() -> Bool {
        return beneficiaryBankAccount != nil
    }
    
    public func isWebmoneyAccount() -> Bool {
        return beneficiaryWebmoneyAccount != nil
    }
    
    public func isTaxAccount() -> Bool {
        return beneficiaryTaxAccount != nil
    }
    
    public func isPayseraAccount() -> Bool {
        return beneficiaryPayseraAccount != nil
    }
}
