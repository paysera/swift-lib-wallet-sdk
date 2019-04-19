import ObjectMapper

public class PSPaymentItem: Mappable {
    public var title: String
    public var itemDescription: String?
    public var imageUri: String?
    public var price: Int?
    public var currency: String?
    public var quantity: Float?
    public var totalPrice: Int?
    public var parameters: [String: Any]?
    
    required public init?(map: Map) {
        do {
            title = try map.value("title")
        } catch {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        if map.mappingType == .toJSON {
            var title = self.title
            
            title        <- map["title"]
        }
        
        itemDescription  <- map["description"]
        imageUri         <- map["image_uri"]
        price            <- map["price"]
        currency         <- map["currency"]
        quantity         <- map["quantity"]
        totalPrice       <- map["total_price"]
        parameters       <- map["parameters"]
    }
}
