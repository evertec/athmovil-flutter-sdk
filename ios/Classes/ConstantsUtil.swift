
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
        static let ATHM_BUILD_QA = ".qa"
        static let ATHM_BUILD_QA_CERT = ".qacert"
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
        static let ATHM_TEST_URL = "https://athmovil-ios-qa.web.app/e-commerce/"
        static let ATHM_PROD_URL = "https://athmovil-ios.web.app/e-commerce/"
        static let ATHM_MOBILE = "mobile"
        static let ATHM_MOBILE_DUMMY = "mobileDummy"
        static let ATHM_MOBILE_SECURE = "mobileSecure"
        static let ATHM_SEND_PAYMENT = "sendPayment"
        static let ATHM_AUTHORIZATION_PAYMENT = "authorizationPayment"
        static let ATHM_API_PAYMENT = "/api/business-transaction/ecommerce/payment"
        static let ATHM_API_AUTHORIZATION = "/api/business-transaction/ecommerce/authorization"
        
    }
}

