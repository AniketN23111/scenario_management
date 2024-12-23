class TestCase {
  String? id;
  String? name;
  String? scenarioId;
  String? description;
  String? comments;
  String? attachment;
  String? status;
  String? assignedUsers;
  String? assignedBy;

  TestCase({
     this.id,
     this.name,
     this.scenarioId,
     this.description,
     this.comments,
     this.attachment,
     this.status,
     this.assignedBy,
     this.assignedUsers,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'scenarioId': scenarioId,
        'description': description,
        'comments': comments,
        'attachment': attachment,
        'status': status,
        'assignedBy': assignedBy,
        'assignedUsers': assignedUsers, // Corrected key name here
      };

  factory TestCase.fromMap(Map<String, dynamic> map) => TestCase(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        scenarioId: map['scenarioId'] ?? '',
        description: map['description'] ?? '',
        comments: map['comments'] ?? '',
        attachment: map['attachment'] ?? '',
        status: map['status'] ?? '',
        assignedBy: map['assignedBy'] ?? '',
        assignedUsers: map['assignedUsers'] ?? '',
      );
}
