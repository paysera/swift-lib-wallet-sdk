import Foundation

public protocol RateLimitUnlockerDelegate {
    /// This method is called when the client has reached the request limit. Until completion is called all future requests will be enqueued
    /// to the queue. Calling completion with `true` will retry previous requests, whereas calling it with `false` will drop all previous
    /// requests. It is the client's responsibility to solve the challenge using the given `url`.
    /// - Parameters:
    ///   - url: URL which should be used to uplift request limit
    ///   - siteKey: Site key used to display the challenge
    ///   - completion: Completion handler which indicates if the challenge was successfully solved. The completion handler is
    ///   called on **the internal work queue**.
    func unlock(url: URL, siteKey: String, completion: (Bool) -> Void)
}
