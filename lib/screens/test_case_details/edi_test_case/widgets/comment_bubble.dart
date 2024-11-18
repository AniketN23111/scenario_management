import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/comments.dart';


class CommentBubble extends StatelessWidget {
  final Comments comment;
  final bool isCurrentUser;

  const CommentBubble({
    required this.comment,
    required this.isCurrentUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Colors.blueAccent.withOpacity(0.8)
            : Colors.black38,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
          bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            Text(
              comment.commentedBy,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 14,
              color:  Colors.white ,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat.yMd()
                .add_jm()
                .format(comment.timestamp ?? DateTime.now()),
            style: const TextStyle(
              fontSize: 10,
              color:   Colors.white ,
            ),
          ),
        ],
      ),
    );
  }
}
