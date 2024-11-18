import 'package:flutter/material.dart';

class AddCommentField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddComment;

  const AddCommentField({
    required this.controller,
    required this.onAddComment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Add a comment',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: onAddComment,
          ),
          filled: true,
          fillColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
