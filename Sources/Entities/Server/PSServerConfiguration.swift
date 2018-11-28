import ObjectMapper

public class PSServerConfiguration: Mappable {
    
    public var minimumPasswordLength: Int
    public var bankTransferUrgentOptionAvailabilityBeneficiaryAccountRegexp: String
    
    required public init?(map: Map) {
        do {
            minimumPasswordLength = try map.value("minimum_password_length")
            bankTransferUrgentOptionAvailabilityBeneficiaryAccountRegexp = try map.value("bank_transfer_urgent_option_availability_beneficiary_account_regexp")
            
        } catch {
            return nil
        }
    }
    
    public init(minimumPasswordLength: Int,
                bankTransferUrgentOptionAvailabilityBeneficiaryAccountRegexp: String) {
        self.minimumPasswordLength = minimumPasswordLength
        self.bankTransferUrgentOptionAvailabilityBeneficiaryAccountRegexp = bankTransferUrgentOptionAvailabilityBeneficiaryAccountRegexp
    }
    
    public func mapping(map: Map) {
        minimumPasswordLength                                           <- map["minimum_password_length"]
        bankTransferUrgentOptionAvailabilityBeneficiaryAccountRegexp    <- map["bank_transfer_urgent_option_availability_beneficiary_account_regexp"]
    }
}
