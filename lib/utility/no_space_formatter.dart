import 'package:flutter/services.dart';

class NoSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    // If the new text contains spaces, revert to the old value
    if (newText.contains(' ')) {
      return oldValue;
    }
    return newValue;
  }
}
