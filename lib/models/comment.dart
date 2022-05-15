import 'package:prorum_flutter/models/user.dart';

class Comment{
  final int commentId;
  final String content;
  final User user;

  const Comment({
    required this.commentId,
    required this.content,
    required this.user,
  });


  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['id'],
      content: json['content'],
      user: User.fromJson(json['user']),
    );
  }
}