import 'package:flutter/material.dart';
import '../../../../models/comments.dart';
import '../../../../models/user_model.dart';
import 'comment_bubble.dart';

class CommentsSection extends StatelessWidget {
  final List<Comments> commentList;
  final UserModel userModel;

  const CommentsSection({
    required this.commentList,
    required this.userModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: commentList.length,
        reverse: true,
        itemBuilder: (context, index) {
          final comment = commentList[index];
          final isCurrentUser = comment.commentedBy == userModel.name;
          return Align(
            alignment: isCurrentUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: CommentBubble(comment: comment, isCurrentUser: isCurrentUser),
          );
        },
      ),
    );
  }
}
