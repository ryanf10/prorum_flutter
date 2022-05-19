
import 'package:flutter/widgets.dart';

class DetailCategory {
  final int categoryId;
  final String name;
  Image? image;
  final int postCount;

  DetailCategory({
    required this.categoryId,
    required this.name,
    required this.postCount,
    this.image,
  });

  String formatPostCount(){
    if(postCount > 1){
      return '$postCount posts';
    }else{
      return '$postCount post';
    }
  }

  factory DetailCategory.fromJson(Map<String, dynamic> json) {
    return DetailCategory(
      categoryId: json['id'],
      name: json['name'],
      postCount: int.parse(json['posts_count']),
    );
  }
}
