// custom_text_form_field.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  );
}
