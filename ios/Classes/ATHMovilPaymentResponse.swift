
import Foundation

struct ATHMovilPaymentResponse: Codable {
    var status: ATHMStatus?
    var referenceNumber: String?
    var dailyTransactionID: Int?
    let version: String?
    let paymentFlow: String?
    let total: Double?
    let subtotal: Double?
    let tax: Double?
    let metadata1: String?
    let metadata2: String?
    let items: [Item]
    let date: String?
    let name: String?
    let phoneNumber: String?
    let email: String?
    var fee: Double?
    var netAmount: Double?
}
