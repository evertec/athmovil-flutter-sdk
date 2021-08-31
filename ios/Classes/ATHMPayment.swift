
import Foundation

class ATHMPayment {
    let paymentId: String
    let publicToken: String
    let paymentJson: String
    
    init(paymentId: String, publicToken: String, paymentJson: String) {
        self.paymentId = paymentId
        self.publicToken = publicToken
        self.paymentJson = paymentJson
    }
}
