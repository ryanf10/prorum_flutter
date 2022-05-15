import 'package:prorum_flutter/models/category.dart';
import 'package:prorum_flutter/models/user.dart';

class DetailPost {
  final int postId;
  final String title;
  final String description;
  String? base64Image;
  Category category;
  User user;
  bool isFavorited;
  DateTime deleteableBefore;

  DetailPost(
      {required this.postId,
      required this.title,
      required this.description,
      this.base64Image,
      required this.isFavorited,
      required this.category,
      required this.user,
      required this.deleteableBefore});

  factory DetailPost.fromJson(Map<String, dynamic> json) {
    return DetailPost(
      postId: json['id'],
      title: json['title'],
      description: json['description'],
      isFavorited: json['isFavorited'] == 1 ? true : false,
      category: Category.fromJson(json['category']),
      user: User.fromJson(json['user']),
      deleteableBefore: DateTime.parse(json['deleteableBefore']),
    );
  }
}
