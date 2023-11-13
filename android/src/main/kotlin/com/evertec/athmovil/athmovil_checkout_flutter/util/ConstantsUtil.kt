package com.evertec.athmovil.athmovil_checkout_flutter.util

class ConstantsUtil {
    object RequestConstants {
        const val ATHM_PAYMENT_ID = "paymentId"
        const val ATHM_APP_PATH = "com.evertec.athmovil.android"
        const val ATHM_REQUIRED_VERSION = 185
        const val ATHM_MARKET_URL = "market://details?id=com.evertec.athmovil.android"
        const val ATHM_BUNDLE = "bundleID"
        const val ATHM_JSON_DATA = "jsonData"
        const val ATHM_REFERENCE_NUMBER = "referenceNumber"
        const val ATHM_PAYMENT_DURATION_TIME = "purchaseTimeOut"
        const val ATHM_API_ROUTE = "/rs/eCommerceTransfer/consultTransactionStatus/"
        const val ATHM_MAX_TIMEOUT: Long = 600000 //10 min
        const val ATHM_MIN_TIMEOUT: Long = 60000 // 1 min
        const val ATHM_CHANNEL_NAME = "com.evertecinc/athmovil_checkout_flutter"
        const val ATHM_CHANNEL_OPENATHM = "openATHM"
        const val ATHM_PAYMENT = "payment"
        const val ATHM_TIMEOUT = "timeout"
        const val ATHM_BUILD_TYPE = "buildType"
        const val ATHM_BUSINESS_TOKEN = "businessToken"
        const val ATHM_PAYMENT_RESULT = "paymentResult"
        const val ATHM_CANCELLED_RESULT = "CancelledPayment"
        const val ATHM_FAILED_RESULT = "FailedPayment";
        const val ATHM_COMPLETED_RESULT = "CompletedPayment";
        const val ATHM_DUMMY_TOKEN = "dummy"
        const val ATHM_INTERNAL_TEST_URL = "https://192.168.234.77:8082"
        const val ATHM_PRODUCTION_URL = "https://www.athmovil.com"
        const val ATHM_PILOTO_URL = "https://piloto.athmovil.com"
        const val ATHM_AWS_QA_URL = "ozm9fx7yw5-vpce-0c7145d0436fe328e.execute-api.us-east-1.amazonaws.com"
        const val ATHM_AWS_CERT_URL = "gej11zn24l-vpce-009e80de2a5fcea32.execute-api.us-east-1.amazonaws.com"
        const val ATHM_AWS_PROD_URL = "ze9tdonfjl-vpce-0dbf78eed6413b115.execute-api.us-east-1.amazonaws.com"
        const val ATHM_API_PAYMENT = "/api/business-transaction/ecommerce/payment"
        const val ATHM_API_AUTHORIZATION = "/api/business-transaction/ecommerce/authorization"
        const val ATHM_SEND_PAYMENT = "sendPayment"
        const val ATHM_SEND_PAYMENT_RESULT = "sendPaymentResult"
        
    }

    object ErrorConstants{
        //Strings for exceptions and logs
        const val ATHM_LOG_TAG = "athmCheckoutValidation"
        const val ATHM_NULL_ATHMPAYMENT_LOG_MESSAGE = "ATHMPayment is null."
        const val ATHM_NULL_CONTEXT_LOG_MESSAGE = "Context is null."
        const val ATHM_PAYMENT_VALIDATION_FAILED = "Error getting response from webservice"
        const val ATHM_NULL_PUBLICTOKEN_LOG_MESSAGE = "BusinessToken is null or empty."
        const val ATHM_TOTAL_ERROR_LOG_MESSAGE = "Total data type value is invalid."

        const val ATHM_SUBTOTAL_ERROR_LOG_MESSAGE = "Subtotal data type value is invalid."
        const val ATHM_ITEM_TOTAL_ERROR_LOG_MESSAGE = "Item's price data type value is invalid."
        const val ATHM_ITEM_QUANTITY_ERROR_LOG_MESSAGE = "Item's quantity data type value is invalid."
        const val ATHM_ITEM_NAME_ERROR_LOG_MESSAGE = "Item's name value is invalid."
        const val ATHM_ITEM_DESC_ERROR_LOG_MESSAGE = "Item's description value is invalid."
        const val ATHM_NULL_METADATA_LOG_MESSAGE = "The metadata data type value is invalid."
        const val ATHM_NULL_ITEM_METADATA_LOG_MESSAGE = "Item's metadata value is invalid."
        const val ATHM_ENCODE_JSON_LOG_MESSAGE = "An error occurred while encoding JSON."
        const val ATHM_DECODE_JSON_LOG_MESSAGE = "An error occurred while decoding JSON."

        const val ATHM_SCHEMA_ERROR_MESSAGE = "Url scheme value is invalid."
        const val ATHM_RESPONSE_EXCEPTION_TITLE = "Error in response"
        const val ATHM_REQUEST_EXCEPTION_TITLE = "Error in request"
        const val ATHM_RESPONSE_NULL_EXCEPTION = "Empty response."
        const val ATHM_TAX_NULL_LOG_MESSAGE = "Tax data type value is invalid."
        const val ATHM_RESPONSE_EXCEPTION = "Sorry for the inconvenience. Please try again later."

        const val ATHM_DATE_PATTERN = "EEE MMM dd HH:mm:ss zzz yyyy"
        const val ATHM_EXCEPTION = "exception"
        const val ATHM_ERROR_CODE = "errorCode"
        const val ATHM_EXCEPTION_CAUSE = "exceptionCause" 
    }
}