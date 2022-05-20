import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/detail_category.dart';
import 'package:prorum_flutter/screens/post/posts_by_category_screen.dart';
import 'package:prorum_flutter/screens/post/posts_screen.dart';

class ListDetailCategories extends StatelessWidget {
  final List<DetailCategory> detailCategories;
  final VoidCallback whenComplete;
  const ListDetailCategories({
    Key? key,
    required this.detailCategories,
    required this.whenComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: detailCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: GestureDetector(
              child: Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: detailCategories[index].image,
                      ),
                    ),
                    Text(
                      detailCategories[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      detailCategories[index].formatPostCount(),
                    ),

                    // ListTile(
                    //   title: Text(
                    //     detailCategories[index].name,
                    //     style: const TextStyle(fontWeight: FontWeight.bold),
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    //   subtitle: Text(
                    //     detailCategories[index].formatPostCount(),
                    //   ),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (BuildContext context) {
                    //           return PostsScreen(
                    //             url: baseApiUrl +
                    //                 "/forum/posts?category=${detailCategories[index].categoryId}&sortBy=time&dir=desc",
                    //             title: detailCategories[index].name,
                    //           );
                    //         },
                    //       ),
                    //     ).whenComplete(() {
                    //       whenComplete();
                    //     });
                    //   },
                    //   trailing: const Icon(Icons.arrow_forward_ios),
                    // ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PostsByCategoryScreen(
                        categoryId: detailCategories[index].categoryId,
                        title: detailCategories[index].name,
                      );
                    },
                  ),
                ).whenComplete(() {
                  whenComplete();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
