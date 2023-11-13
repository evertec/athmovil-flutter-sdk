import 'package:athmovil_checkout_flutter/model/athmovil_payment_response.dart';

abstract class ATHMovilPaymentResponseListener {
  void onCompletedPayment(ATHMovilPaymentResponse athMovilPaymentResponse);

  void onCancelledPayment(ATHMovilPaymentResponse athMovilPaymentResponse);

  void onExpiredPayment(ATHMovilPaymentResponse athMovilPaymentResponse);

  void onPaymentException(String error, String description);

  void onFailedPayment(ATHMovilPaymentResponse athMovilPaymentResponse);
}
