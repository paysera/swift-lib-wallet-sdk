public enum PSNotificationObjectType: String {
    case confirmation
    case statement
    case transactionRequest = "transaction_request"
    case pendingPayment = "pending_payment"
    case information
    case user
    case card
    case identityDocument = "identity_document"
    case recurrenceTransfer = "recurrence_transfer"
}
