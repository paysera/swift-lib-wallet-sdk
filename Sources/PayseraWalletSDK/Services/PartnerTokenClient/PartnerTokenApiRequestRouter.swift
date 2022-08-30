import Alamofire
import Foundation

enum PartnerTokenApiRequestRouter {
    // POST
    case getPartnerTokens(PSPartnerOAuthRequest)

    private static let baseURL = URL(string: "https://wallet.paysera.com/oauth/v1")!
    
    private var method: HTTPMethod {
        switch self {
        case .getPartnerTokens:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .getPartnerTokens:
            return "partner-tokens"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getPartnerTokens(let partnerData):
            return partnerData.toJSON()
        }
    }
}

// MARK: - URLRequestConvertible

extension PartnerTokenApiRequestRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        switch self {
        case .getPartnerTokens:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
