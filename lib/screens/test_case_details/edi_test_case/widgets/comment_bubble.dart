import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/comments.dart';

class CommentBubble extends StatelessWidget {
  final Comments comment;
  final bool isCurrentUser;

  const CommentBubble({
    required this.comment,
    required this.isCurrentUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.60,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).primaryColor.withOpacity(0.4)
              : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
            bottomRight:
            isCurrentUser ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser)
              Text(
                comment.commentedBy,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              comment.content,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (comment.imageUrl != null && comment.imageUrl!.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://dev.orderbookings.com${comment.imageUrl}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://dev.orderbookings.com${comment.imageUrl}',
                        height: 100, // Set thumbnail height
                        width: double.infinity, // Constrain width
                        fit: BoxFit.cover, // Adjust image scaling
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMd()
                  .add_jm()
                  .format(comment.timestamp ?? DateTime.now()),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
