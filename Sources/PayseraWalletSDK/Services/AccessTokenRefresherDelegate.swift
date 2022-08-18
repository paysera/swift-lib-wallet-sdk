public protocol AccessTokenRefresherDelegate {
    func activeCredentialsDidUpdate(to activeCredentials: PSCredentials)
    func inactiveCredentialsDidUpdate(to inactiveCredentials: PSCredentials?)
    func refreshTokenIsInvalid(_ error: Error, refreshToken: String?)
    func shouldRefreshTokenBeforeRequest(with activeCredentials: PSCredentials) -> Bool
}

public extension AccessTokenRefresherDelegate {
    func shouldRefreshTokenBeforeRequest(with activeCredentials: PSCredentials) -> Bool {
        false
    }
}
