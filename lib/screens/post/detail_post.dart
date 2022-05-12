import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/models/post.dart';

class DetailPost extends StatelessWidget {
  final Post post;
  const DetailPost({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: Text(
          post.title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
    );
  }
}
