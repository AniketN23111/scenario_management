import 'comment.dart';

class TestCase {
  String id;
  String name;
  String scenarioId;
  String bugId;
  List<String> tags;
  String description;
  List<Comment> comments;
  String attachment;
  String status;

  TestCase({
    required this.id,
    required this.name,
    required this.scenarioId,
    required this.bugId,
    required this.tags,
    required this.description,
    required this.comments,
    required this.attachment,
    required this.status
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'scenarioId': scenarioId,
    'bugId': bugId,
    'tags': tags,
    'description': description,
    'comments': comments.map((comment) => comment.toMap()).toList(),
    'attachment': attachment,
    'status' : status
  };

  factory TestCase.fromMap(Map<String, dynamic> map) => TestCase(
    id: map['id'],
    name: map['name'],
    scenarioId: map['scenarioId'],
    bugId: map['bugId'],
    tags: List<String>.from(map['tags']),
    description: map['description'],
    comments: (map['comments'] as List)
        .map((commentMap) => Comment.fromMap(commentMap))
        .toList(),
    attachment: map['attachment'],
    status: map['status'],
  );
}
