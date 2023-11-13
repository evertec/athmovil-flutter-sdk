
import Foundation

struct PaymentResponse: Codable {
    let status: String?
    let message: String?
    let errorcode: String?
    let data: PaymentResponseData?
}

struct PaymentResponseData: Codable {
    let ecommerceId: String?
    let auth_token: String?
}
