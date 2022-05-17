import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/rounded_rectangle_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/post.dart';
import 'package:prorum_flutter/screens/home/components/rounded_toogle_button.dart';
import 'package:prorum_flutter/screens/post/components/list_posts.dart';
import 'package:prorum_flutter/screens/post/detail_post_screen.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({Key? key}) : super(key: key);

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  bool isLoading = true;
  double selectedIndex = -1;
  List<Post> posts = [];
  List<Post> duplicateActivePosts = [];
  List<Post> duplicateAllPosts = [];
  List<Post> duplicateFavoritesPosts = [];

  String? query;
  TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future getPosts() async {
    final responseAll =
        await FetchApi.get(baseApiUrl + '/forum/posts?sortBy=time&dir=desc');

    final bodyAll = jsonDecode(responseAll.body);

    if (bodyAll['statusCode'] == 200) {
      for (int i = 0; i < bodyAll['data'].length; i++) {
        duplicateAllPosts.add(Post.fromJson(bodyAll['data'][i]));
      }
    }

    final responseFavorite =
        await FetchApi.get(baseApiUrl + '/forum/favorites');

    final bodyFavorite = jsonDecode(responseFavorite.body);

    if (bodyFavorite['statusCode'] == 200) {
      for (int i = 0; i < bodyFavorite['data'].length; i++) {
        duplicateFavoritesPosts
            .add(Post.fromJson(bodyFavorite['data'][i]['post']));
      }
    }

    if (selectedIndex == -1) {
      setState(() {
        posts = duplicateAllPosts;
        duplicateActivePosts = duplicateAllPosts;
        isLoading = false;
      });
    } else if (selectedIndex == 1) {
      setState(() {
        posts = duplicateFavoritesPosts;
        duplicateActivePosts = duplicateFavoritesPosts;
        isLoading = false;
      });
    }
  }

  Future refreshData() async {
    setState(() {
      isLoading = true;
    });
    duplicateAllPosts = [];
    duplicateActivePosts = [];
    duplicateFavoritesPosts = [];
    await getPosts();
    updateListData();
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
      for (int i = 0; i < duplicateActivePosts.length; i++) {
        if (duplicateActivePosts[i]
                .title
                .toLowerCase()
                .contains(query!.toLowerCase()) ||
            duplicateActivePosts[i]
                .category
                .name
                .toLowerCase()
                .contains(query!.toLowerCase())) {
          temp.add(duplicateActivePosts[i]);
        }
      }
      setState(() {
        posts = temp;
      });
    } else {
      setState(() {
        posts = duplicateActivePosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      color: kPrimaryColor,
      child: !isLoading
          ? Column(
              children: [
                RoundedRectangleInputField(
                  hintText: "search",
                  onChanged: searchItem,
                  icon: Icons.search,
                  controller: controllerSearch,
                  isError: false,
                ),
                RoundedToogleButton(
                  selected: selectedIndex,
                  onTapAll: () {
                    setState(() {
                      // posts = duplicateAllPosts;
                      duplicateActivePosts = duplicateAllPosts;
                      selectedIndex = -1;
                    });
                    updateListData();
                  },
                  onTapFavorites: () {
                    setState(() {
                      // posts = duplicateFavoritesPosts;
                      duplicateActivePosts = duplicateFavoritesPosts;
                      selectedIndex = 1;
                    });
                    updateListData();
                  },
                ),
                ListPosts(
                  posts: posts,
                  whenComplete: () {
                    refreshData();
                    setState(() {
                      controllerSearch.text = query ?? '';
                    });
                    updateListData();
                  },
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
