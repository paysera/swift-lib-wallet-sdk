public enum PSNotificationEventType: String {
    case created
    case alert
    case registered
    case transactionSuccessful = "transaction_successful"
    case reviewStatusValid = "review_status_valid"
    case reviewStatusDenied = "review_status_denied"
    case canceled
    case expired
    case failed
    case done
    case filled
    case withdrew
    case automatedFillMade = "automated_fill_made"
    case delivered
}
