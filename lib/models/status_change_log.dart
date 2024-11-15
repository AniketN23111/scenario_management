import 'package:cloud_firestore/cloud_firestore.dart';

class StatusChange {
  final String status;
  final String updatedBy;
  final DateTime? updatedAt;  // Nullable DateTime field

  // Constructor
  StatusChange({
    required this.status,
    required this.updatedBy,
    this.updatedAt,  // Allow nullable DateTime for updatedAt
  });

  // Factory method to create an instance from Firestore DocumentSnapshot
  factory StatusChange.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Safely handle the nullable updatedAt field
    return StatusChange(
      status: data['status'] ?? '',  // Default to empty string if null
      updatedBy: data['createdBy'] ?? '',  // Default to empty string if null
      updatedAt: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()  // Convert Timestamp to DateTime if not null
          : null,  // Set null if 'updatedAt' is null in Firestore
    );
  }
}
