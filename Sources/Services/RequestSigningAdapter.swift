import Alamofire
import CommonCrypto

public class RequestSigningAdapter: RequestInterceptor {
    private let credentials: PSCredentials
    private let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol
    
    init(credentials: PSCredentials,
         serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol) {
        
        self.credentials = credentials
        self.serverTimeSynchronizationProtocol = serverTimeSynchronizationProtocol
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = credentials.accessToken, let macKey = credentials.macKey else { return }
        
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
        
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
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
        var contentsHash = (body != nil) ? "body_hash=\(self.generateSHA256String(body!).addPercentEncoding())" : ""
        let nonce = generateRandomStringOfLength(32)
        let timeStamp = String(format: "%.0f", Date().timeIntervalSince1970 + timeDiff)
        let pathRange = requestURL.absoluteString.range(of: (requestURL.path))
        let fullPath = requestURL.absoluteString.substring(from: (pathRange?.lowerBound)!)
        contentsHash.append(extraParameters)
        let items: [String] = [timeStamp, nonce, httpMethod.uppercased(), fullPath, (requestURL.host)!, port, contentsHash, ""]
        let dataString = items.joined(separator: "\n")
        
        let macValue = generateMAC(dataString, key: macKey)
        
        return String(format: "MAC id=\"%@\", ts=\"%@\", nonce=\"%@\", mac=\"%@\", ext=\"%@\"", arguments: [accessToken, timeStamp, nonce, macValue, contentsHash])
    }
    
    private func generateRandomStringOfLength(_ lenght : Int) -> String {
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: lenght)
        
        for _ in 0...lenght {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
    
    private func generateMAC(_ dataString: String, key: String) -> String {
        let secretKey = key.cString(using: String.Encoding.utf8)
        let dataToDigest = dataString.cString(using: String.Encoding.utf8)
        
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        
        var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), secretKey!, Int(strlen(secretKey!)), dataToDigest!, Int(strlen(dataToDigest!)), &result)
        
        let hmacData:Data = Data(bytes: UnsafePointer<UInt8>(result), count: digestLength)
        return hmacData.base64EncodedString(options: .lineLength64Characters)
    }
    
    private func generateSHA256String(_ data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
}
