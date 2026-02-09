
public struct ConstantsUtil {

    struct request {
        static let ATHM_DUMMY = "dummy"
        static let ATHM_PAYMENT = "payment"
        static let ATHM_PUBLIC_TOKEN = "publicToken"
        static let ATHM_PAYMENT_ID_TOKEN = "paymentId"
        static let ATHM_TIMEOUT = "timeout"
        static let ATHM_RESULT = "result"
        static let ATHM_ERROR = "exception"
        static let ATHM_SUCCESS = "success"
        static let ATHM_APPSTORE = "appstore"
        static let ATHM_BUILD_TYPE = "buildType"
        static let ATHM_DUMMY_URL = "athm://paymentSimulated/"
        static let ATHM_URL = "athm://payment/"
        static let ATHM_TRANSACTION_DATA = "transaction_data"
        static let ATHM_EMPTY_STRING = "transaction_data"
        static let ATHM_APPSTORE_URL = "itms://itunes.apple.com/sg/app/ath-movil/id658539297?l=zh&mt=8"
        static let ATHM_RETURN_DATA = "athm_payment_data"
        static let ATHM_CANCELLED_RESULT = "CancelledPayment"
        static let ATHM_FAILED_RESULT = "FailedPayment"
    }

    struct call {
        static let ATHM_METHOD_OPENATHM = "openATHM"
        static let ATHM_CHANNEL_NAME = "com.evertecinc/athmovil_checkout_flutter"
        static let ATHM_PAYMENT_RESULT = "paymentResult"
        static let ATHM_PAYMENT_URL = "/rs/eCommerceTransfer/consultTransactionStatus"
        static let ATHM_PROD_URL = "https://athmovil-ios.web.app/e-commerce/"
        static let ATHM_MOBILE = "mobile"
        static let ATHM_MOBILE_DUMMY = "mobileDummy"
        static let ATHM_MOBILE_SECURE = "mobileSecure"
        static let ATHM_SEND_PAYMENT = "sendPayment"
        static let ATHM_AUTHORIZATION_PAYMENT = "authorizationPayment"
        static let ATHM_API_PAYMENT = "/api/business-transaction/ecommerce/payment"
        static let ATHM_API_AUTHORIZATION = "/api/business-transaction/ecommerce/authorization"
        
    }
    struct nr {
        static let NR_CONSTANT = "c@0d!4f#a3@9f$f!b6@8c#8$8@9!3#3@1a$0@1!5b#a$e!d0@d5#b@F!F$F@F#N!R@A$L"
        static let URL_CONSTANT = "h@t!t#p$s@:!/@/i@n!s#i$g@h!t#s$-@c!o#l$l@e!c#t$o@r!.#n$e@w!r#e$l@i!c#.$c@o!m#/$v@1!/#a$c@c!o#u$n@t!s#/$3@4!1#0$8@5!4#/$e@v!e#n$t@s"
        static let INIT_PAYMENT_SUCCESS = "ATHMSuccessPaymentInitEvent"
        static let INIT_PAYMENT_FAILURE = "ATHMFailedPaymentInitEvent"
        static let FINISH_PAYMENT_SUCCESS = "ATHMSuccessPaymentEvent"
        static let FINISH_PAYMENT_FAILURE = "ATHMFailedPaymentEvent"
        static let INIT_NETWORK_ERROR = "NETWORK_ERROR_INIT_PAYMENT"
        static let FAILED_ERROR = "FAILED"
    }
}

