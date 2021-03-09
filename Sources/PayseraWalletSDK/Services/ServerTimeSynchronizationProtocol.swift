import Foundation

public protocol ServerTimeSynchronizationProtocol {
    func getServerTimeDifference() -> TimeInterval
    func serverTimeDifferenceRefreshed(diff: TimeInterval)
}
