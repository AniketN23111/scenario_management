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
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.40,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(8),
        // Reduced padding
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Colors.blueAccent.withOpacity(0.8)
              : Colors.black38,
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
                  color: Colors.white,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              comment.content,
              style: const TextStyle(
                fontSize: 15, // Compact font size
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat.yMd()
                      .add_jm()
                      .format(comment.timestamp ?? DateTime.now()),
                  style: const TextStyle(
                    fontSize: 10, // Smaller timestamp font
                    color: Colors.white,
                  ),
                ),
                if (comment.imageUrl != null && comment.imageUrl!.isNotEmpty)
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
                    child: const Icon(
                      Icons.image,
                      size: 18, // Smaller icon size
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
