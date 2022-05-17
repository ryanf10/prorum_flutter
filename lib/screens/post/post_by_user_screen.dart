import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/rounded_rectangle_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/post.dart';
import 'package:prorum_flutter/screens/post/components/list_posts.dart';

class PostByUserScreen extends StatefulWidget {
  final int userId;
  final String title;
  PostByUserScreen({
    Key? key,
    required this.userId,
    required this.title,
  }) : super(key: key);

  @override
  State<PostByUserScreen> createState() => _PostByUserScreenState();
}

class _PostByUserScreenState extends State<PostByUserScreen> {
  List<Post> posts = [];
  List<Post> duplicateAllPosts = [];
  bool isLoading = true;

  Future getPosts() async {
    final responseAll =
        await FetchApi.get(baseApiUrl + '/forum/posts/user/${widget.userId}');

    final bodyAll = jsonDecode(responseAll.body);
    print(bodyAll);

    if (bodyAll['statusCode'] == 200) {
      for (int i = 0; i < bodyAll['data'].length; i++) {
        duplicateAllPosts.add(Post.fromJson(bodyAll['data'][i]));
      }
    }

    print(duplicateAllPosts);

    setState(() {
      posts = duplicateAllPosts;
      isLoading = false;
    });
  }

  searchItem(value){
    if (value != null && value != '') {
      List<Post> temp = [];
      for (int i = 0; i < duplicateAllPosts.length; i++) {
        if (duplicateAllPosts[i]
                .title
                .toLowerCase()
                .contains(value!.toLowerCase()) ||
            duplicateAllPosts[i]
                .category
                .name
                .toLowerCase()
                .contains(value!.toLowerCase())) {
          temp.add(duplicateAllPosts[i]);
        }
      }
      setState(() {
        posts = temp;
      });
    } else {
      setState(() {
        posts = duplicateAllPosts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: Text(widget.title),
      ),
      body: !isLoading
          ? Column(
              children: [
                RoundedRectangleInputField(
                  hintText: "search",
                  onChanged: searchItem,
                  icon: Icons.search,
                  controller: null,
                  isError: false,
                ),
                ListPosts(
                  posts: posts,
                  whenComplete: () {},
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
    );
  }
}
