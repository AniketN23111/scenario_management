import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final String id;
  final String testCaseId; // ID of the associated test case
  final String content; // The comment text
  final String commentedBy; // Name of the user who made the comment
  final DateTime? timestamp; // Timestamp when the comment was created
  final String? imageUrl;

  Comments({
    required this.id,
    required this.testCaseId,
    required this.content,
    required this.commentedBy,
    required this.timestamp,
    required this.imageUrl,
  });

  // Factory constructor to create a Comment from Firestore document data
  factory Comments.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comments(
      id: doc.id,
      testCaseId: data['id'] ?? '',
      content: data['text'] ?? '',
      commentedBy: data['createdBy'] ?? '',
      timestamp: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Method to convert a Comment instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'testCaseId': testCaseId,
      'content': content,
      'commentedBy': commentedBy,
      'timestamp': timestamp,
      'imageUrl' :imageUrl
    };
  }
}
