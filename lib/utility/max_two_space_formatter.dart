import 'package:flutter/services.dart';

class MaxTwoSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final spaceCount = newText.split('').where((char) => char == ' ').length;

    if (spaceCount > 1) {
      return oldValue;
    }
    return newValue;
  }

}
