

import 'package:athmovil_checkout_flutter/model/athmovil_payment.dart';

class ATHMovilPaymentSingleton {
  static final ATHMovilPaymentSingleton _athMovilPaymentSingleton =
      ATHMovilPaymentSingleton._internal();

  ATHMovilPaymentSingleton._internal();
  late ATHMovilPayment athMovilPayment;

  factory ATHMovilPaymentSingleton() {
    return _athMovilPaymentSingleton;
  }

  static ATHMovilPaymentSingleton get athMovilPaymentSingleton =>
      _athMovilPaymentSingleton;

  factory ATHMovilPaymentSingleton.withPayment(
      ATHMovilPayment athMovilPayment) {
    athMovilPayment = athMovilPayment;
    return _athMovilPaymentSingleton;
  }
}
