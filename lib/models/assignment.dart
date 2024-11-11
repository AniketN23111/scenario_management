class Assignment {
  String bugId;
  List<String> assignedUsers;
  String assignedBy;

  Assignment({
    required this.bugId,
    required this.assignedUsers,
    required this.assignedBy,
  });

  Map<String, dynamic> toMap() => {
    'bugId': bugId,
    'assignedUsers': assignedUsers,
    'assignedBy': assignedBy,
  };

  factory Assignment.fromMap(Map<String, dynamic> map) => Assignment(
    bugId: map['bugId'],
    assignedUsers: List<String>.from(map['assignedUsers']),
    assignedBy: map['assignedBy'],
  );
}
