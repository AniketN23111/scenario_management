// custom_text_form_field.dart
import 'package:flutter/material.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required String label,
  required String hintText,
  int? maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey.shade100,
    ),
    maxLines: maxLines,
  );
}
