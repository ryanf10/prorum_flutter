import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/detail_category.dart';
import 'package:prorum_flutter/screens/home/components/bottom_navbar.dart';
import 'package:prorum_flutter/screens/home/components/left_drawer.dart';
import 'package:prorum_flutter/screens/home/components/list_detail_categories.dart';
import 'package:prorum_flutter/screens/home/feed_tab_screen.dart';

class CategoryTabScreen extends StatefulWidget {
  const CategoryTabScreen({Key? key}) : super(key: key);

  @override
  State<CategoryTabScreen> createState() => _CategoryTabScreenState();
}

class _CategoryTabScreenState extends State<CategoryTabScreen> {
  bool isLoading = true;
  List<DetailCategory> detailCategories = [];

  int stateSort = 1;
  // 0:id desc, 1:id asc, 2: post count desc, 3: post count asc

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getCategories();
  }

  getCategories() async {
    final response = await FetchApi.get(baseApiUrl + '/forum/categories');
    final body = jsonDecode(response.body);

    List<DetailCategory> temp = [];
    for (int i = 0; i < body['data'].length; i++) {
      temp.add(DetailCategory.fromJson(body['data'][i]));
    }

    for (int i = 0; i < temp.length; i++) {
      temp[i].image = Image.network(
        baseApiUrl + "/forum/categories/${temp[i].categoryId}/image",
        headers: FetchApi.headers,
        fit: BoxFit.cover,
      );
    }
    setState(() {
      detailCategories = sortDetailCategory(temp);
      isLoading = false;
    });
  }

  List<DetailCategory> sortDetailCategory(List<DetailCategory> a) {
    if (stateSort == 0) {
      a.sort((DetailCategory x, DetailCategory y) =>
          x.categoryId > y.categoryId ? -1 : 1);
    } else if (stateSort == 1) {
      a.sort((DetailCategory x, DetailCategory y) =>
          x.categoryId > y.categoryId ? 1 : -1);
    } else if (stateSort == 2) {
      a.sort((DetailCategory x, DetailCategory y) =>
          x.postCount > y.postCount ? -1 : 1);
    } else if (stateSort == 3) {
      a.sort((DetailCategory x, DetailCategory y) =>
          x.postCount > y.postCount ? 1 : -1);
    }
    return a;
  }

  changeSort() {
    setState(() {
      sortDetailCategory(detailCategories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: const Text(
          'Category',
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
                              title: const Text('Default'),
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
                                    stateSort = stateSort - 2;
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
                              title: const Text('Post Count'),
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
                                    stateSort = stateSort + 2;
                                  });
                                }
                                changeSort();
                                Navigator.pop(context);
                              },
                              trailing: (stateSort == 2)
                                  ? const Icon(Icons.arrow_upward)
                                  : (stateSort == 3)
                                      ? const Icon(Icons.arrow_downward)
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            icon: const Icon(
              Icons.filter_alt_outlined,
            ),
          ),
        ],
      ),
      body: !isLoading
          ? RefreshIndicator(
              onRefresh: refreshData,
              child: Column(
                children: [
                  ListDetailCategories(
                    detailCategories: detailCategories,
                    whenComplete: refreshData,
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: BottomNavbar(
        currentTabIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const FeedTabScreen();
                },
              ),
            );
          }
        },
      ),
    );
  }
}
