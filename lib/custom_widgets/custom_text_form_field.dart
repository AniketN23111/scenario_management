import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaxTwoSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    // Count the number of spaces in the text
    final spaceCount = newText.split('').where((char) => char == ' ').length;

    // If spaces are more than 2, revert to the old value
    if (spaceCount > 2) {
      return oldValue;
    }
    return newValue;
  }
}

Widget buildTextFormField({
  required TextEditingController controller,
  required String label,
  required String hintText,
  required bool enabled,
  int? maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    enabled: enabled,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    ),
    maxLines: maxLines,
    inputFormatters: [
      MaxTwoSpacesFormatter(), // Custom formatter to allow a maximum of 2 spaces
    ],
  );
}
