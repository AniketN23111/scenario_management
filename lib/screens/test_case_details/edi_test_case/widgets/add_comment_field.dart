import 'package:flutter/material.dart';

class AddCommentField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddComment;

  const AddCommentField({
    required this.controller,
    required this.onAddComment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Add a comment',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: onAddComment,
        ),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
