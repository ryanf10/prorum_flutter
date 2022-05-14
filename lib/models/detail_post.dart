import 'package:prorum_flutter/models/user.dart';

class DetailPost {
  final int postId;
  final String title;
  final String description;
  String? base64Image;
  User user;
  bool isFavorited;

  DetailPost({
    required this.postId,
    required this.title,
    required this.description,
    this.base64Image,
    required this.isFavorited,
    required this.user,
  });

  factory DetailPost.fromJson(Map<String, dynamic> json) {
    return DetailPost(
      postId: json['id'],
      title: json['title'],
      description: json['description'],
      isFavorited: json['isFavorited'] == 1 ? true : false,
      user: User.fromJson(json['user']),
    );
  }
}
