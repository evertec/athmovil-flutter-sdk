import 'package:flutter/cupertino.dart';

enum Style { orange, light, dark }

enum Lang { en, es }

class ConstantsUtil {
  static const String ATHM_PACKAGE_NAME = "athmovil_checkout_flutter";

  /// THEME STYLES
  static const String ATHM_DEFAULT_THEME = "default";
  static const String ATHM_LIGHT_THEME = "light";
  static const String ATHM_DARK_THEME = "dark";
  static const String ATHM_DEFAULT = "Default";

  /// THEME COLORS
  static const Color ATHM_DARK_COLOR = Color.fromARGB(255, 76, 76, 76);
  static const Color ATHM_LIGHT_COLOR = Color.fromARGB(255, 255, 255, 255);
  static const Color ATHM_DEFAULT_COLOR = Color.fromARGB(255, 245, 124, 0);
  static const Color ATHM_WHITE_COLOR = Color.fromARGB(255, 255, 255, 255);
  static const Color ATHM_BLACK_COLOR = Color.fromARGB(255, 0, 0, 0);
  static const int ATHM_MAX_TIMEOUT = 600000; //10 min
  static const int ATHM_MIN_TIMEOUT = 60000; // 1 min

  /// ASSETS
  static const String ATHM_ASSETS = "assets/";
  static const String ATHM_TXT_BTN_BLACK = "pay-button-image-black.png";
  static const String ATHM_TXT_BTN_BLACK_ES = "pay-button-image-black-es.png";
  static const String ATHM_TXT_BTN_WHITE = "pay-button-image-white.png";
  static const String ATHM_TXT_BTN_WHITE_ES = "pay-button-image-white-es.png";

  /// ERROR MESSAGES
  static const String ATHM_FAILED_RESULT = "FailedPayment";
  static const String ATHM_CANCELLED_RESULT = "CancelledPayment";
  static const String ATHM_EXPIRED_RESULT = "ExpiredPayment";
  static const String ATHM_EXPIRED = "EXPIRED";
  static const String ATHM_CANCELLED = "CANCELLED";
  static const String ATHM_FAILED = "FAILED";
  static const String ATHM_COMPLETED = "COMPLETED";
  static const String ATHM_CANCELLED_iOS_RESULT = "cancelled";
  static const String ATHM_EXPIRED_iOS_RESULT = "expired";
  static const String ATHM_FAILED_iOS_RESULT = "failed";
  static const String ATHM_PAYMENT_VALIDATION_FAILED =
      "Error getting response from webservice";
  static const String ATHM_NULL_PUBLICTOKEN_ERROR_MESSAGE =
      "BusinessToken is null or empty.";
  static const String ATHM_METADATA1_ERROR_MESSAGE =
      "Metadata1 can not be greater than 40 characters";
  static const String ATHM_METADATA2_ERROR_MESSAGE =
      "Metadata2 can not be greater than 40 characters";
  static const String ATHM_TOTAL_ERROR_MESSAGE =
      "Total data type value is invalid.";
  static const String ATHM_SUBTOTAL_ERROR_MESSAGE =
      "Subtotal data type value is invalid.";
  static const String ATHM_BUSINESS_TOKEN_MESSAGE =
      "BusinessToken is null or empty";
  static const String ATHM_ITEM_TOTAL_ERROR_MESSAGE =
      "Item's price data type value is invalid.";
  static const String ATHM_ITEM_QUANTITY_ERROR_MESSAGE =
      "Item's quantity data type value is invalid.";
  static const String ATHM_ITEM_NAME_ERROR_MESSAGE =
      "Item's name value is invalid.";
  static const String ATHM_ITEM_DESC_ERROR_MESSAGE =
      "Item's description value is invalid.";
  static const String ATHM_NULL_METADATA_ERROR_MESSAGE =
      "The metadata data type value is invalid.";
  static const String ATHM_NULL_ITEM_METADATA_ERROR_MESSAGE =
      "Item's metadata value is invalid.";
  static const String ATHM_ENCODE_JSON_ERROR_MESSAGE =
      "An error occurred while encoding JSON.";
  static const String ATHM_DECODE_JSON_ERROR_MESSAGE =
      "An error occurred while decoding JSON.";
  static const String ATHM_TAX_NULL_ERROR_MESSAGE =
      "Tax data type value is invalid.";
  static const String ATHM_SCHEMA_ERROR_MESSAGE =
      "Url scheme value is invalid.";
  static const String ATHM_PAYMENT_ERROR_MESSAGE =
      "ATHMovilPayment is invalid.";
  static const String ATHM_EXCEPTION_TITLE = "Something went wrong...";
  static const String ATHM_EXCEPTION_MESSAGE =
      "Sorry for the inconvenience. Please try again later.";
  static const String ATHM_RESPONSE_EXCEPTION_TITLE = "Error in Response";
  static const String ATHM_REQUEST_EXCEPTION_TITLE = "Error in Request";
  static const String ATHM_EXCEPTION = "exception";
  static const String ATH_PAYMENT_VALIDATION_FAILED =
      "Error getting response from webservice";
}
