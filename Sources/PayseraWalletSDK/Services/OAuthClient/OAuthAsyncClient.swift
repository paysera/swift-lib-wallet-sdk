import PromiseKit

public class OAuthAsyncClient: BaseAsyncClient {
    
    public func loginUser(_ userLoginData: PSUserLoginRequest) -> Promise<PSCredentials> {
        doRequest(requestRouter: OAuthApiRequestRouter.login(userLoginData))
    }
    
    public func refreshToken(
        _ refreshToken: String,
        grantType: PSGrantType = .refreshToken,
        code: String? = nil,
        scopes: [String]? = nil
    ) -> Promise<PSCredentials> {
        let refreshTokenRequest = PSRefreshTokenRequest()
        refreshTokenRequest.grantType = grantType.rawValue
        refreshTokenRequest.refreshToken = refreshToken
        refreshTokenRequest.scopes = scopes
        refreshTokenRequest.code = code
        
        return doRequest(requestRouter: OAuthApiRequestRouter.refreshToken(refreshTokenRequest))
    }
    
    public func revoke(accessToken: String) -> Promise<PSBeneficiaryPayseraAccount> {
        doRequest(requestRouter: OAuthApiRequestRouter.revoke(accessToken: accessToken))
    }
    
    public func activate(accessToken: String) -> Promise<PSCredentials>{
        doRequest(requestRouter: OAuthApiRequestRouter.activate(accessToken: accessToken))
    }
    
    public func getPartnerTokens(
        payload: PSPartnerTokensOAuthRequest
    ) -> Promise<PSPartnerTokensOAuthResponse> {
        doRequest(requestRouter: OAuthApiRequestRouter.getPartnerTokens(payload))
    }
}
