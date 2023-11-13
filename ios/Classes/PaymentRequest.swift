
import Foundation

struct PaymentRequest: Codable {
    var env: String?
    let publicToken: String?
    let businessToken: String?
    var timeout: Int?
    let total: Decimal?
    let tax: Decimal?
    let subtotal: Decimal?
    let metadata1: String?
    let metadata2: String?
    let items: [Item]
    let phoneNumber: String?
    let callbackSchema: String?

    enum CustomKeys: String, CodingKey {
        case env
        case timeout
        case total
        case tax
        case subtotal
        case metadata1
        case metadata2
        case items
        case phoneNumber
        case callbackSchema
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let publicTokenValue = try container.decodeIfPresent(String.self, forKey: .publicToken) {
            self.publicToken = publicTokenValue
        } else {
            // Si la clave "publicToken" no está presente, intentamos decodificar "businessToken"
            let businessTokenValue = try container.decode(String.self, forKey: .businessToken)
            self.publicToken = businessTokenValue
        }
        self.businessToken = try container.decode(String.self, forKey: .businessToken)
        // Resto de la inicialización
        self.env = try container.decodeIfPresent(String.self, forKey: .env)
        self.timeout = try container.decodeIfPresent(Int.self, forKey: .timeout)
        self.total = try container.decodeIfPresent(Decimal.self, forKey: .total)
        self.tax = try container.decodeIfPresent(Decimal.self, forKey: .tax)
        self.subtotal = try container.decodeIfPresent(Decimal.self, forKey: .subtotal)
        self.metadata1 = try container.decodeIfPresent(String.self, forKey: .metadata1)
        self.metadata2 = try container.decodeIfPresent(String.self, forKey: .metadata2)
        self.items = try container.decodeIfPresent([Item].self, forKey: .items) ?? []
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.callbackSchema = try container.decodeIfPresent(String.self, forKey: .callbackSchema)
    }
}

struct Item: Codable {
    var description: String?
    var desc: String?
    let metadata: String?
    let name: String?
    let price: Decimal?
    let tax: Decimal?
    let quantity: Int?
}



