import 'package:prorum_flutter/models/user.dart';

class Comment {
  final int commentId;
  final String content;
  final User user;
  final DateTime createdAt;

  const Comment({
    required this.commentId,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['id'],
      content: json['content'],
      user: User.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
