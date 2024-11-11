import 'package:cloud_firestore/cloud_firestore.dart';

class Scenario {
  String id;
  String name;
  String project;
  String description;
  DateTime createdAt;
  String createdBy;

  Scenario({
    required this.id,
    required this.name,
    required this.project,
    required this.description,
    required this.createdAt,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'project': project,
    'description': description,
    'createdAt': createdAt,
    'createdBy': createdBy,
  };

  factory Scenario.fromMap(Map<String, dynamic> map) => Scenario(
    id: map['id'],
    name: map['name'],
    project: map['project'],
    description: map['description'],
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    createdBy: map['createdBy'],
  );
}
