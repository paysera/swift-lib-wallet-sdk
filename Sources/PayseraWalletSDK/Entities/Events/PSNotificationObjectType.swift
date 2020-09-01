import Foundation

public enum PSNotificationObjectType: String {
    case confirmation
    case statement
    case transactionRequest = "transaction_request"
    case pendingPayment = "pending_payment"
    case information
    case user
}
