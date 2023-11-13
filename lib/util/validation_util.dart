import 'package:athmovil_checkout_flutter/model/athmovil_exception.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment.dart';
import 'package:athmovil_checkout_flutter/util/constants_util.dart';

class ATHMovilValidationUtil {
  static ATHMovilException? _exception;

  static ATHMovilException? validateRequest(ATHMovilPayment athMovilPayment) {
    _exception = null;
    if (!validatePurchaseDataDouble(athMovilPayment.subtotal, 0.0)) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_SUBTOTAL_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if (!validatePurchaseDataDouble(athMovilPayment.tax, 0.0)) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_TAX_NULL_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if (athMovilPayment.businessToken == null ||
        athMovilPayment.businessToken!.trim().isEmpty) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_BUSINESS_TOKEN_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if (athMovilPayment.total == null ||
        !validatePurchaseDataDouble(athMovilPayment.total, 1.0)) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_TOTAL_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if (!validatePurchaseDataString(athMovilPayment.callbackSchema)) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_SCHEMA_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if (!validatePurchaseDataString(athMovilPayment.businessToken)) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_NULL_PUBLICTOKEN_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if ((athMovilPayment.metadata1 != null &&
            athMovilPayment.metadata1!.isNotEmpty) &&
        athMovilPayment.metadata1!.length > 40) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_METADATA1_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if ((athMovilPayment.metadata2 != null &&
            athMovilPayment.metadata2!.isNotEmpty) &&
        athMovilPayment.metadata2!.length > 40) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_METADATA2_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    } else if ((athMovilPayment.timeout != null) &&
        (athMovilPayment.timeout! > 0 && athMovilPayment.timeout! < 60 ||
            athMovilPayment.timeout! > 600)) {
      _exception = ATHMovilException(
          exceptionMessage: ConstantsUtil.ATHM_METADATA2_ERROR_MESSAGE,
          exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
    }
    validatePurchaseItemsData(athMovilPayment);
    return _exception;
  }

  static bool validatePurchaseDataDouble(
      double? doubleString, double minValue) {
    if (doubleString == null) {
      return true;
    } else {
      return !(doubleString < minValue);
    }
  }

  static bool validatePurchaseDataString(String? dataString) {
    return (dataString != null && (dataString.trim()).isNotEmpty);
  }

  static bool validatePurchaseItemsData(ATHMovilPayment request) {
    if (request.items != null) {
      for (ATHMovilItem item in request.items!) {
        if (!validatePurchaseDataString(item.name)) {
          _exception = ATHMovilException(
              exceptionMessage: ConstantsUtil.ATHM_ITEM_NAME_ERROR_MESSAGE,
              exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
          return false;
        } else if (item.price == null ||
            !validatePurchaseDataDouble(item.price, 1.0)) {
          _exception = ATHMovilException(
              exceptionMessage: ConstantsUtil.ATHM_ITEM_TOTAL_ERROR_MESSAGE,
              exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
          return false;
        } else if (item.quantity == null ||
            !validatePurchaseDataDouble(item.quantity!.toDouble(), 1.0)) {
          _exception = ATHMovilException(
              exceptionMessage: ConstantsUtil.ATHM_ITEM_QUANTITY_ERROR_MESSAGE,
              exceptionTitle: ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE);
          return false;
        }
      }
    }
    return true;
  }

  static int setTimeout(int? timeout) {
    if (timeout == null || timeout < ConstantsUtil.ATHM_MIN_TIMEOUT) {
      return ConstantsUtil.ATHM_MIN_TIMEOUT;
    } else if (timeout > ConstantsUtil.ATHM_MAX_TIMEOUT) {
      return ConstantsUtil.ATHM_MAX_TIMEOUT;
    } else {
      return timeout;
    }
  }
}
