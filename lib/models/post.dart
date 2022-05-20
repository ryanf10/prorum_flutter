import 'package:prorum_flutter/models/category.dart';

class Post {
  final int postId;
  final String title;
  final String description;
  String? base64Image;
  Category category;
  DateTime createdAt;

  Post({
    required this.postId,
    required this.title,
    required this.description,
    this.base64Image,
    required this.category,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['id'],
      title: json['title'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
