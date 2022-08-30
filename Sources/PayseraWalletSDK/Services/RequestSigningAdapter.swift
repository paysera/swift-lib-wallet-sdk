import Alamofire
import CryptoSwift
import Foundation
import PayseraCommonSDK

public class RequestSigningAdapter: RequestInterceptor {
    private let credentials: PSCredentials
    private let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol
    private let logger: PSLoggerProtocol?
    
    init(
        credentials: PSCredentials,
        serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol,
        logger: PSLoggerProtocol? = nil
    ) {
        self.credentials = credentials
        self.serverTimeSynchronizationProtocol = serverTimeSynchronizationProtocol
        self.logger = logger
    }
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard let accessToken = credentials.accessToken, let macKey = credentials.macKey else {
            return completion(.failure(PSApiError.unauthorized()))
        }
        
        let authorizationValue = generateSignature(
            accessToken,
            macKey: macKey,
            timeDiff: serverTimeSynchronizationProtocol.getServerTimeDifference(),
            body: urlRequest.httpBody,
            requestURL: urlRequest.url!,
            httpMethod: urlRequest.httpMethod!,
            extraParameters: urlRequest.value(forHTTPHeaderField: "extraParameters") ?? ""
        )
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(authorizationValue))
        urlRequest.setValue(nil, forHTTPHeaderField: "extraParameters")
        completion(.success(urlRequest))
    }
        
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        completion(.doNotRetry)
    }
    
    private func generateSignature(
        _ accessToken: String,
        macKey: String,
        timeDiff: Double,
        body: Data?,
        requestURL: URL,
        httpMethod: String,
        extraParameters: String
    ) -> String {
        let port = "443"
        var contentsHash = (body != nil) ? "body_hash=\(body!.sha256().base64EncodedString().addPercentEncoding())" : ""
        
        let nonce = randomStringOfLength(64)
        logger?.log(level: .DEBUG, message: "Generated nonce \(nonce) for \(requestURL.absoluteURL) ")
        
        let timeStamp = String(format: "%.0f", Date().timeIntervalSince1970 + timeDiff)
        let pathRange = requestURL.absoluteString.range(of: (requestURL.path))
        #warning("❌ Change the deprecated function")
        let fullPath = requestURL.absoluteString.substring(from: (pathRange?.lowerBound)!)
        contentsHash.append(extraParameters)
        let items: [String] = [timeStamp, nonce, httpMethod.uppercased(), fullPath, (requestURL.host)!, port, contentsHash, ""]
        let dataString = items.joined(separator: "\n")
        
        guard
            let bytes = try? HMAC(key: macKey, variant: .sha2(.sha256))
                .authenticate(dataString.bytes)
        else {
            return ""
        }
        
        let macValue = bytes.toBase64()
        return String(
            format: "MAC id=\"%@\", ts=\"%@\", nonce=\"%@\", mac=\"%@\", ext=\"%@\"",
            arguments: [accessToken, timeStamp, nonce, macValue, contentsHash]
        )
    }
    
    private func randomStringOfLength(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
