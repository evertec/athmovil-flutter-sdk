import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';

class ATHMovilPayment {
  ATHMovilPayment({
    required this.businessToken,
    required this.callbackSchema,
    required this.total,
    required this.timeout,
    this.paymentId,
    this.tax,
    this.subtotal,
    this.metadata1,
    this.metadata2,
    this.items,
  });

  final String? businessToken;
  final double? total;
  final String? callbackSchema;
  int? timeout;
  final double? subtotal;
  final double? tax;
  String? metadata1;
  String? metadata2;
  String? paymentId;
  final List<ATHMovilItem>? items;

  factory ATHMovilPayment.fromMap(Map<String, dynamic> data) {
    return ATHMovilPayment(
      businessToken: data['businessToken'],
      callbackSchema: data['callbackSchema'],
      timeout: data['timeout'],
      total: data['total'],
      paymentId: data['paymentId'],
      subtotal: data['subtotal'],
      tax: data['tax'],
      metadata1: data['metadata1'],
      metadata2: data['metadata2'],
      items: data['itemsSelectedList'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessToken': businessToken,
      'callbackSchema': callbackSchema,
      'timeout': timeout,
      'total': total,
      'paymentId': paymentId,
      'subtotal': subtotal,
      'tax': tax,
      'metadata1': metadata1,
      'metadata2': metadata2,
      'itemsSelectedList': items,
      'scheme': callbackSchema,
      'traceId': paymentId,
    };
  }

  Map toJson() => {
        'businessToken': businessToken,
        'callbackSchema': callbackSchema,
        'timeout': timeout,
        'total': total,
        'paymentId': paymentId,
        'subtotal': subtotal,
        'tax': tax,
        'metadata1': metadata1,
        'metadata2': metadata2,
        'itemsSelectedList': items,
        //ios names
        //'publicToken': businessToken,
        'items': items,
        'scheme': callbackSchema,
        'version': "3.0",
        'traceId': paymentId,
        'expiresIn': timeout
      };
}
