import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String commentText;
  final String userId;
  final String userName;
  final Timestamp createdAt;

  Comment({
    required this.id,
    required this.commentText,
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  // From Firestore
  factory Comment.fromJson(Map<String, dynamic> json, String id) {
    return Comment(
      id: id,
      commentText: json['commentText'],
      userId: json['userId'],
      userName: json['userName'],
      createdAt: json['createdAt'],
    );
  }

  // To Firestore
  Map<String, dynamic> toJson() {
    return {
      'commentText': commentText,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt,
    };
  }
}
