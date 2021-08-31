import 'dart:async';
import 'dart:convert';

import 'package:athmovil_checkout_flutter/model/athmovil_exception.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment_response.dart';
import 'package:athmovil_checkout_flutter/util/constants_util.dart';
import 'package:athmovil_checkout_flutter/util/singleton_util.dart';
import 'package:athmovil_checkout_flutter/util/validation_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'interfaces/athmovil_payment_response_listener.dart';

class AthmovilCheckoutFlutter {
  static const CHANNEL_NAME = "com.evertecinc/athmovil_checkout_flutter";
  static const MethodChannel _channel = const MethodChannel(CHANNEL_NAME);
  static ATHMovilPaymentResponseListener? _responseListener;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> openATHMovil({
    ATHMovilPayment? athMovilPayment,
    String? buildType,
    ATHMovilPaymentResponseListener? athMovilPaymentResponseListener,
  }) async {
    _responseListener = athMovilPaymentResponseListener;
    _channel.setMethodCallHandler(callHandler);
    if (athMovilPayment == null) {
      _responseListener!.onPaymentException(
          ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE,
          ConstantsUtil.ATHM_PAYMENT_ERROR_MESSAGE);
      return false;
    }
    athMovilPayment.paymentId = Uuid().v1();
    ATHMovilPaymentSingleton.athMovilPaymentSingleton.athMovilPayment =
        athMovilPayment;
    ATHMovilException? athMovilException =
        ATHMovilValidationUtil.validateRequest(athMovilPayment);
    if (athMovilException == null) {
      String json = encodeRequest(athMovilPayment);
      if (json.isNotEmpty) {
        final String? version = await _channel.invokeMethod(
          'openATHM',
          {
            "payment": json,
            "buildType": buildType,
            "publicToken": ATHMovilPaymentSingleton
                .athMovilPaymentSingleton.athMovilPayment.businessToken,
            "paymentId": ATHMovilPaymentSingleton
                .athMovilPaymentSingleton.athMovilPayment.paymentId,
            "timeout": ATHMovilPaymentSingleton
                .athMovilPaymentSingleton.athMovilPayment.timeout,
          },
        );
        return true;
      }
      return false;
    } else {
      _responseListener!.onPaymentException(
          athMovilException.exceptionTitle, athMovilException.exceptionMessage);
      return false;
    }
  }

  static Future<dynamic> callHandler(MethodCall methodCall) async {
    print(methodCall.method + " flutter");
    switch (methodCall.method) {
      case 'paymentResult':
        _validateResponse(methodCall.arguments.toString());
        return true;
      case 'exception':
        _responseListener!.onPaymentException(
            ConstantsUtil.ATHM_RESPONSE_EXCEPTION_TITLE,
            ConstantsUtil.ATH_PAYMENT_VALIDATION_FAILED);
        return true;
      default:
        return false;
    }
  }

  static String encodeRequest(ATHMovilPayment payment) {
    try {
      return jsonEncode(payment);
    } catch (e) {
      _responseListener!.onPaymentException(
          ConstantsUtil.ATHM_REQUEST_EXCEPTION_TITLE,
          ConstantsUtil.ATHM_ENCODE_JSON_ERROR_MESSAGE);
    }
    return "";
  }

  static ATHMovilPaymentResponse? decodeResponse(String payment) {
    try {
      Map<String, dynamic>? map = jsonDecode(payment);
      return ATHMovilPaymentResponse.fromMap(map);
    } catch (e) {
      _responseListener!.onPaymentException(
          ConstantsUtil.ATHM_RESPONSE_EXCEPTION_TITLE,
          ConstantsUtil.ATHM_DECODE_JSON_ERROR_MESSAGE);
    }
    return null;
  }

  // TODO  Check the Date param with David, it was passing as a null value
  static void _validateResponse(String response) {
    ATHMovilPaymentResponse? paymentResponse;
    switch (response) {
      case ConstantsUtil.ATHM_CANCELLED_RESULT:
        paymentResponse = ATHMovilPaymentResponse.setCancelledPaymentResponse();
        _responseListener!.onCancelledPayment(paymentResponse);
        return;
      case ConstantsUtil.ATHM_EXCEPTION:
        _responseListener!.onPaymentException(
            ConstantsUtil.ATHM_RESPONSE_EXCEPTION_TITLE,
            ConstantsUtil.ATH_PAYMENT_VALIDATION_FAILED);
        return;
      default:
        paymentResponse = decodeResponse(response);
        if (paymentResponse == null) {
          return;
        } else if (paymentResponse.status ==
                ConstantsUtil.ATHM_CANCELLED_RESULT ||
            paymentResponse.status == ConstantsUtil.ATHM_CANCELLED_iOS_RESULT) {
          paymentResponse.status = ConstantsUtil.ATHM_CANCELLED;
          _responseListener!.onCancelledPayment(paymentResponse);
          return;
        } else if (paymentResponse.status ==
                ConstantsUtil.ATHM_EXPIRED_RESULT ||
            paymentResponse.status == ConstantsUtil.ATHM_EXPIRED_iOS_RESULT) {
          paymentResponse.status = ConstantsUtil.ATHM_EXPIRED;
          _responseListener!.onExpiredPayment(paymentResponse);
          return;
        } else {
          paymentResponse.status = ConstantsUtil.ATHM_COMPLETED;
          _responseListener!.onCompletedPayment(paymentResponse);
          return;
        }
    }
  }

  @visibleForTesting
  void validateResponse(
      String response, ATHMovilPaymentResponseListener listener) {
    _responseListener = listener;
    _validateResponse(response);
  }

  @visibleForTesting
  void setListener(ATHMovilPaymentResponseListener listener) {
    _responseListener = listener;
  }

  @visibleForTesting
  ATHMovilPaymentResponse? decodeResponseTest(String payment) {
    return decodeResponse(payment);
  }
}
