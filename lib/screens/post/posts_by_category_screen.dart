import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/screens/home/components/floating_button.dart';
import 'package:prorum_flutter/components/rounded_rectangle_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/post.dart';
import 'package:prorum_flutter/screens/post/components/list_posts.dart';
import 'package:prorum_flutter/screens/post/create_post_screen.dart';

class PostsByCategoryScreen extends StatefulWidget {
  final int categoryId;
  final String title;
  const PostsByCategoryScreen({
    Key? key,
    required this.categoryId,
    required this.title,
  }) : super(key: key);

  @override
  State<PostsByCategoryScreen> createState() => _PostsByCategoryScreenState();
}

class _PostsByCategoryScreenState extends State<PostsByCategoryScreen> {
  List<Post> posts = [];
  List<Post> duplicateAllPosts = [];
  bool isLoading = true;
  String? query;
  TextEditingController controllerSearch = TextEditingController();

  Future getPosts() async {
    final responseAll = await FetchApi.get(baseApiUrl +
        "/forum/posts?category=${widget.categoryId}&sortBy=time&dir=desc");

    final bodyAll = jsonDecode(responseAll.body);

    if (bodyAll['statusCode'] == 200) {
      for (int i = 0; i < bodyAll['data'].length; i++) {
        duplicateAllPosts.add(Post.fromJson(bodyAll['data'][i]));
      }
    }

    setState(() {
      posts = duplicateAllPosts;
      isLoading = false;
    });
  }

  searchItem(value) {
    setState(() {
      query = value;
    });
    updateListData();
  }

  updateListData() {
    if (query != null && query != '') {
      List<Post> temp = [];
      for (int i = 0; i < duplicateAllPosts.length; i++) {
        if (duplicateAllPosts[i]
                .title
                .toLowerCase()
                .contains(query!.toLowerCase()) ||
            duplicateAllPosts[i]
                .category
                .name
                .toLowerCase()
                .contains(query!.toLowerCase())) {
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

  Future refreshData() async {
    setState(() {
      duplicateAllPosts = [];
      isLoading = true;
    });
    await getPosts();
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
          ? RefreshIndicator(
              onRefresh: refreshData,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedRectangleInputField(
                    hintText: "search",
                    onChanged: searchItem,
                    icon: Icons.search,
                    controller: controllerSearch,
                    isError: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListPosts(
                    posts: posts,
                    whenComplete: () async {
                      await refreshData();
                      setState(() {
                        controllerSearch.text = query ?? '';
                      });
                      updateListData();
                    },
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
      floatingActionButton: FloatingButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return CreatePostScreen(
                  defaultCategory: widget.categoryId,
                );
              },
            ),
          ).whenComplete(() async {
            await refreshData();
            setState(() {
              controllerSearch.text = query ?? '';
            });
            updateListData();
          });
        },
      ),
    );
  }
}
