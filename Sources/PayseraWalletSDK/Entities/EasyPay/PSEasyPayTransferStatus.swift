import ObjectMapper

public struct PSEasyPayTransferStatus: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension PSEasyPayTransferStatus {
    public static let new = PSEasyPayTransferStatus(rawValue: "new")
    public static let created = PSEasyPayTransferStatus(rawValue: "created")
    public static let failed = PSEasyPayTransferStatus(rawValue: "failed")
    public static let cancelled = PSEasyPayTransferStatus(rawValue: "cancelled")
    public static let done = PSEasyPayTransferStatus(rawValue: "done")
    public static let expired = PSEasyPayTransferStatus(rawValue: "expired")
    public static let processingCancellation = PSEasyPayTransferStatus(rawValue: "processing_cancellation")
    public static let deniedCancellation = PSEasyPayTransferStatus(rawValue: "cancellation_denied")
}

extension PSEasyPayTransferStatus {
    class Transform: TransformType {
        func transformFromJSON(_ value: Any?) -> PSEasyPayTransferStatus? {
            guard let value = value as? String else {
                return nil
            }
            return PSEasyPayTransferStatus(rawValue: value)
        }

        func transformToJSON(_ value: PSEasyPayTransferStatus?) -> String? {
            value?.rawValue
        }
    }
}
