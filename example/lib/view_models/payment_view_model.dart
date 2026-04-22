import 'package:athmovil_checkout_dummy/utils/local_storage_key_utils.dart';
import 'package:athmovil_checkout_dummy/utils/utils.dart';
import 'package:athmovil_checkout_flutter/util/constants_util.dart';
import 'package:flutter/material.dart';

class PaymentViewModel with ChangeNotifier {
  Lang? lang;
  Style? style;
  String? environment;
  String? businessToken;
  double? paymentAmount;
  String? callbackSchema;
  int? timeout;
  double? subtotal;
  double? tax;
  String? metadata1;
  String? metadata2;
  String? paymentId;
  String? traceId;
  String? scheme;
  String? phoneNumber;
  String? newFlow;
  String? publicToken;
  bool isLoading = false;

  Future<void> fetchInitialValues() async {
    businessToken = await Utils().getPrefsString(key: PUBLIC_TOKEN_PREF_KEY) ?? "dummy";
    timeout = await Utils().getPrefsInt(key: TIMEOUT_PREF_KEY) ?? 0;
    paymentAmount =
        await Utils().getPrefsDouble(key: PAYMENT_AMOUNT_PREF_KEY) ?? 0;
    style = await getTheme();
    environment =
        await Utils().getPrefsString(key: BUILD_TYPE_PREF_KEY) ?? "Production";
    lang = await getLang();
    subtotal = await Utils().getPrefsDouble(key: SUBTOTAL_PREF_KEY) ?? 0.00;
    tax = await Utils().getPrefsDouble(key: TAX_PREF_KEY) ?? 0.00;
    metadata1 = await Utils().getPrefsString(key: METADATA1_PREF_KEY) ?? "";
    metadata2 = await Utils().getPrefsString(key: METADATA2_PREF_KEY) ?? "";
    newFlow = "YES";
    phoneNumber = await Utils().getPrefsString(key: PHONE_NUMBER_PREF_KEY) ?? "";
    publicToken = businessToken;
    isLoading = false;
    notifyListeners();
  }

  void setPaymentValue({String? valueId, String? value, dynamic dynamicValue}) {
    switch (valueId) {
      case PUBLIC_TOKEN_PREF_KEY:
        businessToken = value;
        Utils().setPrefsString(key: PUBLIC_TOKEN_PREF_KEY, value: value!);
        break;
      case TIMEOUT_PREF_KEY:
        timeout = convertToInt(value);
        Utils().setPrefsInt(
          key: TIMEOUT_PREF_KEY,
          value: timeout!,
        );
        break;
      case PAYMENT_AMOUNT_PREF_KEY:
        paymentAmount = convertToCurrency(value ?? "");
        Utils().setPrefsDouble(
          key: PAYMENT_AMOUNT_PREF_KEY,
          value: paymentAmount!,
        );
        break;
      case THEME_PREF_KEY:
        style = dynamicValue;
        Utils().setPrefsString(
          key: valueId!,
          value: value!,
        );
        break;
      case BUILD_TYPE_PREF_KEY:
        environment = value;
        Utils().setPrefsString(
          key: valueId!,
          value: value!,
        );
        break;
      case LANGUAGE_PREF_KEY:
        lang = dynamicValue;
        Utils().setPrefsString(
          key: valueId!,
          value: value!,
        );
        break;
      case NEW_FLOW_PREF_KEY:
        newFlow = value;
        Utils().setPrefsString(
          key: valueId!,
          value: value!,
        );
        break;
      case SUBTOTAL_PREF_KEY:
        subtotal = convertToCurrency(value ?? "");
        Utils().setPrefsDouble(
          key: SUBTOTAL_PREF_KEY,
          value: subtotal!,
        );
        break;
      case TAX_PREF_KEY:
        tax = convertToCurrency(value ?? "");
        Utils().setPrefsDouble(key: TAX_PREF_KEY, value: tax!);
        break;
      case METADATA1_PREF_KEY:
        metadata1 = value;
        Utils().setPrefsString(
          key: METADATA1_PREF_KEY,
          value: value!.isEmpty ? "" : value,
        );
        break;
      case METADATA2_PREF_KEY:
        metadata2 = value;
        Utils().setPrefsString(
          key: METADATA2_PREF_KEY,
          value: value!.isEmpty ? "" : value,
        );
        break;
      case PHONE_NUMBER_PREF_KEY:
        phoneNumber = value;
        Utils().setPrefsString(
          key: PHONE_NUMBER_PREF_KEY,
          value: value!.isEmpty ? "" : value,
        );
        break;
      default:
        break;
    }
    notifyListeners();
  }

  Future<Style?> getTheme() async {
    final theme = await Utils().getPrefsString(key: THEME_PREF_KEY);
    if (theme != null) {
      return Style.values.firstWhere((e) => e.toString() == theme);
    } else {
      return null;
    }
  }

  Future<Lang?> getLang() async {
    final lang = await Utils().getPrefsString(key: LANGUAGE_PREF_KEY);
    if (lang != null) {
      return Lang.values.firstWhere((e) => e.toString() == lang);
    } else {
      return null;
    }
  }

  double convertToCurrency(String value) {
    try {
      String _onlyDigits = value.replaceAll(
        RegExp('[^-?[0-9]\d*(\.\d+)?\$]'),
        "",
      );
      var result = double.parse(_onlyDigits);
      return result;
    } catch (e) {
      return 0.0;
    }
  }

  double convertToDouble(String? value) {
    try {
      if (value != null) {
        String _onlyDigits = value.replaceAll(
          RegExp('[^0-9]'),
          "",
        );

        return double.parse(_onlyDigits) / 100;
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  int convertToInt(String? value) {
    try {
      if (value != null) {
        return int.parse(value);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  showLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
