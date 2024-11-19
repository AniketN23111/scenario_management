import 'package:flutter/material.dart';

class AddCommentField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAddComment;
  final VoidCallback imageUpload;

  AddCommentField({
    required this.controller,
    required this.onAddComment,
    required this.imageUpload,
    super.key,
  });

  @override
  State<AddCommentField> createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: 'Add a comment',
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: widget.imageUpload,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: widget.onAddComment,
              ),
            ],
          ),
          filled: true,
          fillColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
