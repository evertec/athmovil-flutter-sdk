import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.maxDigits});

  final int? maxDigits;

  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits != null && newValue.selection.baseOffset > maxDigits!) {
      return oldValue;
    }
    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("#,##0.00", "en_US");
    String newText = formatter.format(value / 100);
    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}
