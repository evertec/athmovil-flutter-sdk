import 'dart:core';

import 'package:athmovil_checkout_flutter/interfaces/athmovil_payment_response_listener.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment_response.dart';
import 'package:athmovil_checkout_flutter/open_athmovil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockATH extends Mock implements AthmovilCheckoutFlutter {}

class MockResponse extends Mock implements ATHMovilPaymentResponse {}

class MockCallbackFunction extends Mock
    implements ATHMovilPaymentResponseListener {
  @override
  void onCancelledPayment(ATHMovilPaymentResponse? athMovilPaymentResponse) {}

  @override
  void onCompletedPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {}

  @override
  void onExpiredPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {}

  @override
  void onPaymentException(String error, String description) {}
}

void main() {
  final AthmovilCheckoutFlutter _mockATH = MockATH();
  final MockCallbackFunction _listener = MockCallbackFunction();

  final getCancelledPaymentResponse =
      "{\"status\":\"CancelledPayment\",\"total\":1.12,\"fee\":0.0,\"tax\":0.0,\"subtotal\":0.0," +
          "\"name\":\"Test\",\"phoneNumber\":\"7871234567\",\"email\":\"test@test.com\"," +
          "\"date\":\"Wed Mar 14 15:30:00 EET 2018\",\"dailyTransactionID\":\"0000\"," +
          "\"metadata1\":\"Milk\",\"netAmount\":1.12,\"metadata2\":\"Shake 2\",\"items\":[]}";

  final getExpiredPaymentResponse =
      "{\"status\":\"ExpiredPayment\",\"total\":1.12,\"fee\":0.0,\"tax\":0.0,\"subtotal\":0.0," +
          "\"name\":\"Test\",\"phoneNumber\":\"7871234567\",\"email\":\"test@test.com\"," +
          "\"date\":\"Wed Mar 14 15:30:00 EET 2018\",\"dailyTransactionID\":\"0000\"," +
          "\"metadata1\":\"Milk\",\"netAmount\":1.12,\"metadata2\":\"Shake 2\",\"items\":[]}";

  final getCompletedPaymentResponse =
      "{\"status\":\"CompletedPayment\",\"total\":1.12,\"fee\":0.0,\"tax\":0.0,\"subtotal\":0.0," +
          "\"name\":\"Test\",\"phoneNumber\":\"7871234567\",\"email\":\"test@test.com\"," +
          "\"date\":\"Wed Mar 14 15:30:00 EET 2018\",\"dailyTransactionID\":\"0000\"," +
          "\"metadata1\":\"Milk\",\"netAmount\":1.12,\"metadata2\":\"Shake 2\",\"items\":[]}";

  final _response = new MockResponse();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  test("Complete Response", () async {
    when(
      _mockATH.validateResponse(getCompletedPaymentResponse, _listener),
    ).thenAnswer((realInvocation) => _listener.onCompletedPayment);
  });

  test("Canceled Response", () async {
    when(
      _mockATH.validateResponse(getCancelledPaymentResponse, _listener),
    ).thenAnswer((realInvocation) => _listener.onCancelledPayment);
  });

  test("Expired Response", () async {
    when(
      _mockATH.validateResponse(getExpiredPaymentResponse, _listener),
    ).thenAnswer((realInvocation) => _listener.onExpiredPayment);
  });

  test("Decode", () async {
    when(
      _mockATH.decodeResponseTest(getExpiredPaymentResponse),
    ).thenAnswer((realInvocation) => null);
    expect(_response, _response);
  });
}
