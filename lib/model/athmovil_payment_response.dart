import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';
import 'package:athmovil_checkout_flutter/util/constants_util.dart';
import 'package:athmovil_checkout_flutter/util/singleton_util.dart';
import 'package:intl/intl.dart';

class ATHMovilPaymentResponse {
  ATHMovilPaymentResponse({
    required this.publicToken,
    required this.callbackSchema,
    required this.total,
    required this.timeout,
    this.paymentId,
    this.tax,
    this.subtotal,
    this.metadata1,
    this.metadata2,
    this.items,
    required this.status,
    required this.date,
    this.referenceNumber,
    this.dailyTransactionID,
    this.name,
    this.phoneNumber,
    this.email,
    this.fee,
    this.netAmount,
  });

  final String? publicToken;
  final double? total;
  final String? callbackSchema;
  final int? timeout;
  final double? subtotal;
  final double? tax;
  String? metadata1;
  String? metadata2;
  String? paymentId;
  final List<ATHMovilItem>? items;
  String? status;
  final String? date;
  final String? referenceNumber;
  final String? dailyTransactionID;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final double? fee;
  final double? netAmount;

  factory ATHMovilPaymentResponse.fromMap(Map<String, dynamic>? data) {
    return ATHMovilPaymentResponse(
      publicToken: data?['publicToken'] ?? "",
      callbackSchema: data?['callbackSchema'] ?? "",
      timeout: data?['timeout'] ?? 0,
      total: dataToDouble(data?['total'].toDouble() ?? 0.00),
      paymentId: data?['paymentId'] ?? "",
      subtotal: dataToDouble(data?['subtotal'].toDouble() ?? 0.00),
      tax: dataToDouble(data?['tax'].toDouble() ?? 0.00),
      metadata1: data?['metadata1'] ?? "",
      metadata2: data?['metadata2'] ?? "",
      status: data?['status'] ?? "",
      date: getDate(data?['date'] ?? ""),
      referenceNumber: data?['referenceNumber'] ?? "",
      dailyTransactionID: data?['dailyTransactionID'].toString() ?? "",
      name: data?['name'] ?? "",
      phoneNumber: data?['phoneNumber'] ?? "",
      email: data?['email'],
      fee: dataToDouble(data?['fee'].toDouble() ?? 0.00),
      netAmount: dataToDouble(data?['netAmount'].toDouble() ?? 0.00),
      items: List<ATHMovilItem>.from(
          data?['items'].map((model) => ATHMovilItem.fromMap(model))),
    );
  }

  static String getDate(String date) {
    if (date.isEmpty) {
      DateTime dateFormat = new DateTime.now();
      return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateFormat);
    }
    try {
      var dateFormat = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
      var formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(dateFormat);
      return formattedDate;
    } catch (e) {
      return date.substring(0, date.length - 2);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'publicToken': publicToken,
      'callbackSchema': callbackSchema,
      'timeout': timeout,
      'total': total,
      'paymentId': paymentId,
      'subtotal': subtotal,
      'tax': tax,
      'metadata1': metadata1,
      'metadata2': metadata2,
      'items': items,
      'status': status,
      'date': date,
      'referenceNumber': referenceNumber,
      'dailyTransactionID': dailyTransactionID,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'fee': fee,
      'netAmount': netAmount,
    };
  }

  Map toJson() => {
        'publicToken': publicToken,
        'callbackSchema': callbackSchema,
        'timeout': timeout,
        'total': total,
        'paymentId': paymentId,
        'subtotal': subtotal,
        'tax': tax,
        'metadata1': metadata1,
        'metadata2': metadata2,
        'items': items,
        'status': status,
        'date': date,
        'referenceNumber': referenceNumber,
        'dailyTransactionID': dailyTransactionID,
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'fee': fee,
        'netAmount': netAmount,
      };

  static ATHMovilPaymentResponse setCancelledPaymentResponse() {
    return ATHMovilPaymentResponse(
      publicToken: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.businessToken,
      callbackSchema: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.callbackSchema,
      total: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.total,
      timeout: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.timeout,
      status: ConstantsUtil.ATHM_CANCELLED,
      date: getDate(""),
      subtotal: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.subtotal,
      tax:
          ATHMovilPaymentSingleton.athMovilPaymentSingleton.athMovilPayment.tax,
      metadata1: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.metadata1,
      metadata2: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.metadata2,
      items: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.items,
      referenceNumber: "",
      dailyTransactionID: "",
      name: "",
      phoneNumber: "",
      email: "",
      fee: 0.0,
      netAmount: 0.0,
    );
  }

  static ATHMovilPaymentResponse setChangeStatusPaymentResponse(String status) {
    return ATHMovilPaymentResponse(
      publicToken: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.businessToken,
      callbackSchema: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.callbackSchema,
      total: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.total,
      timeout: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.timeout,
      status: status,
      date: getDate(""),
      subtotal: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.subtotal,
      tax:
          ATHMovilPaymentSingleton.athMovilPaymentSingleton.athMovilPayment.tax,
      metadata1: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.metadata1,
      metadata2: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.metadata2,
      items: ATHMovilPaymentSingleton
          .athMovilPaymentSingleton.athMovilPayment.items,
      referenceNumber: "",
      dailyTransactionID: "",
      name: "",
      phoneNumber: "",
      email: "",
      fee: 0.0,
      netAmount: 0.0,
    );
  }

  static double dataToDouble(double num) {
    return double.parse(num.toStringAsFixed(2));
  }
}
