import Alamofire
import CommonCrypto

public class RequestSigningAdapter: RequestAdapter {
    private let credentials: PSCredentials
    private let serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol
    
    init(credentials: PSCredentials,
         serverTimeSynchronizationProtocol: ServerTimeSynchronizationProtocol) {
        
        self.credentials = credentials
        self.serverTimeSynchronizationProtocol = serverTimeSynchronizationProtocol
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        return sign(request: urlRequest,
                    clientID: credentials.accessToken ?? "",
                    macKey: credentials.macKey ?? "",
                    serverTimeDiff: serverTimeSynchronizationProtocol.getServerTimeDifference())
    }
    
    
    func sign(request: URLRequest, clientID: String, macKey: String, serverTimeDiff: Double) -> URLRequest {
        
        var request = request
        let authorizationValue = generateSignature(clientID, macKey: macKey,
                                                   timeDiff: serverTimeDiff,
                                                   body: request.httpBody,
                                                   requestURL: request.url!,
                                                   httpMethod: request.httpMethod!)
        request.setValue(authorizationValue, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func generateSignature(
        _ accessToken: String,
        macKey: String,
        timeDiff: Double,
        body: Data?,
        requestURL: URL,
        httpMethod: String
    ) -> String {
        
        let port = "443"
        let contentsHash = (body != nil) ? self.generateSHA256String(body!) : ""
        let nonce = generateRandomStringOfLength(32)
        let timeStamp = String(format: "%.0f", Date().timeIntervalSince1970 + timeDiff)
        let pathRange = requestURL.absoluteString.range(of: (requestURL.path))
        let fullPath = requestURL.absoluteString.substring(from: (pathRange?.lowerBound)!)
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
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), &digest)
        
        let output = NSMutableString(capacity: Int(CC_SHA256_DIGEST_LENGTH * 2))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}
