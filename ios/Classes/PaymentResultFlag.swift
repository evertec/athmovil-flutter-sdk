
import Foundation

class PaymentResultFlag {
    static let shared = PaymentResultFlag()
    
    var paymentRequest: ATHMPayment?
    
    private init() {}
    
    func setPaymentRequest(paymentRequest: ATHMPayment?){
        self.paymentRequest = paymentRequest
    }
}
