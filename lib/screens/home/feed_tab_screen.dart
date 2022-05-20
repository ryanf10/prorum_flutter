import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/rounded_rectangle_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/post.dart';
import 'package:prorum_flutter/screens/home/category_tab_screen.dart';
import 'package:prorum_flutter/screens/home/components/bottom_navbar.dart';
import 'package:prorum_flutter/screens/home/components/category_tab.dart';
import 'package:prorum_flutter/screens/home/components/left_drawer.dart';
import 'package:prorum_flutter/screens/home/components/rounded_toogle_button.dart';
import 'package:prorum_flutter/screens/post/components/list_posts.dart';
import 'package:prorum_flutter/screens/post/create_post_screen.dart';

class FeedTabScreen extends StatefulWidget {
  const FeedTabScreen({Key? key}) : super(key: key);

  @override
  State<FeedTabScreen> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends State<FeedTabScreen> {
  bool isLoading = true;
  double selectedIndex = -1;
  List<Post> posts = [];
  List<Post> duplicateActivePosts = [];
  List<Post> duplicateAllPosts = [];
  List<Post> duplicateFavoritesPosts = [];

  int stateSort = 0;
  // 0:time desc, 1:time asc, 2: category name desc, 3: category name asc

  String? query;
  TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  List<Post> sortPost(List<Post> a) {
    if (stateSort == 0) {
      a.sort((Post x, Post y) => x.createdAt.isBefore(y.createdAt) ? 1 : -1);
    } else if (stateSort == 1) {
      a.sort((Post x, Post y) => x.createdAt.isBefore(y.createdAt) ? -1 : 1);
    } else if (stateSort == 2) {
      a.sort((Post x, Post y) => y.category.name.compareTo(x.category.name));
    } else if (stateSort == 3) {
      a.sort((Post x, Post y) => x.category.name.compareTo(y.category.name));
    }
    return a;
  }

  Future getPosts() async {
    final responseAll =
        await FetchApi.get(baseApiUrl + '/forum/posts?sortBy=time&dir=desc');

    final bodyAll = jsonDecode(responseAll.body);
    print(bodyAll);

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
        duplicateAllPosts = duplicateAllPosts;
        posts = sortPost(duplicateAllPosts);
        duplicateActivePosts = duplicateAllPosts;
        isLoading = false;
      });
    } else if (selectedIndex == 1) {
      setState(() {
        posts = sortPost(duplicateFavoritesPosts);
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
        posts = sortPost(temp);
      });
    } else {
      setState(() {
        posts = sortPost(duplicateActivePosts);
      });
    }
  }

  changeSort() {
    setState(() {
      posts = sortPost(posts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: const Text(
          'Feed',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    Size size = MediaQuery.of(context).size;
                    return AlertDialog(
                      content: SizedBox(
                        width: size.width * 0.9,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: const Text('Created At'),
                              onTap: () {
                                if (stateSort == 1) {
                                  setState(() {
                                    stateSort = 0;
                                  });
                                } else if (stateSort == 0) {
                                  setState(() {
                                    stateSort = 1;
                                  });
                                } else {
                                  setState(() {
                                    stateSort = 0;
                                  });
                                }
                                changeSort();
                                Navigator.pop(context);
                              },
                              trailing: (stateSort == 0)
                                  ? const Icon(Icons.arrow_upward)
                                  : (stateSort == 1)
                                      ? const Icon(Icons.arrow_downward)
                                      : null,
                            ),
                            ListTile(
                              title: Text('Category Name'),
                              onTap: () {
                                if (stateSort == 3) {
                                  setState(() {
                                    stateSort = 2;
                                  });
                                } else if (stateSort == 2) {
                                  setState(() {
                                    stateSort = 3;
                                  });
                                } else {
                                  setState(() {
                                    stateSort = 2;
                                  });
                                }
                                changeSort();
                                Navigator.pop(context);
                              },
                              trailing: (stateSort == 2)
                                  ? Icon(Icons.arrow_upward)
                                  : (stateSort == 3)
                                      ? Icon(Icons.arrow_downward)
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            icon: const Icon(
              Icons.filter,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const CreatePostScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
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
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: BottomNavbar(
        currentTabIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const CategoryTabScreen();
                },
              ),
            );
          }
        },
      ),
    );
  }
}
