class Comment {
  String content;
  String attachment;

  Comment({
    required this.content,
    required this.attachment,
  });

  Map<String, dynamic> toMap() => {
    'content': content,
    'attachment': attachment,
  };

  factory Comment.fromMap(Map<String, dynamic> map) => Comment(
    content: map['content'],
    attachment: map['attachment'],
  );
}
