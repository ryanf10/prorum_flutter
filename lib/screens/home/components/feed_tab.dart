import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/rounded_rectangle_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/post.dart';
import 'package:prorum_flutter/screens/post/detail_post.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  List<Post> posts = [];
  List<Post> duplicatePosts = [];

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future getPosts() async {
    final response = await FetchApi.get(baseApiUrl + '/forum/posts');

    final body = jsonDecode(response.body);

    if (body['statusCode'] == 200) {
      for (int i = 0; i < body['data'].length; i++) {
        duplicatePosts.add(Post.fromJson(body['data'][i]));
      }
    }

    setState(() {
      posts = duplicatePosts;
    });
  }

  Future refreshData() async {
    duplicatePosts = [];
    getPosts();
  }

  searchItem(value) {
    if (value != null && value != '') {
      List<Post> temp = [];
      for (int i = 0; i < duplicatePosts.length; i++) {
        if (duplicatePosts[i]
                .title
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            duplicatePosts[i]
                .category
                .name
                .toLowerCase()
                .contains(value.toLowerCase())) {
          temp.add(duplicatePosts[i]);
        }
      }
      setState(() {
        posts = temp;
      });
    } else {
      setState(() {
        posts = duplicatePosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      color: kPrimaryColor,
      child: posts.isNotEmpty
          ? Column(
              children: [
                RoundedRectangleInputField(
                  hintText: "search",
                  onChanged: searchItem,
                  icon: Icons.search,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            posts[index].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(posts[index].category.name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return DetailPost(post: posts[index]);
                                },
                              ),
                            ).whenComplete(() {
                              setState(() {
                                posts = [];
                              });
                              refreshData();
                            });
                          },
                        ),
                      );
                    },
                  ),
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
