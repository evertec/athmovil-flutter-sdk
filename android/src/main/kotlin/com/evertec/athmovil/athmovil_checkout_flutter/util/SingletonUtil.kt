import android.app.Application

class PaymentResultFlag : Application() {
    override fun onCreate() {
        super.onCreate()
        applicationInstance = this
    }

    var paymentRequest: ATHMPayment? = null

    companion object {
        private var applicationInstance = PaymentResultFlag()
        fun getApplicationInstance(): PaymentResultFlag {
            return applicationInstance
        }

        fun setApplicationInstance(applicationInstance: PaymentResultFlag) {
            Companion.applicationInstance = applicationInstance
        }
    }
}

class ATHMPayment(val paymentId: String, val publicToken: String, val paymentJson: String) {

}