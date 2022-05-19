import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/models/detail_category.dart';
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
        itemCount: detailCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(
                detailCategories[index].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                detailCategories[index].formatPostCount(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PostsScreen(
                        url: baseApiUrl + "/forum/posts?category=${detailCategories[index].categoryId}&sortBy=time&dir=desc",
                        title: detailCategories[index].name,
                      );
                    },
                  ),
                ).whenComplete(() {
                  whenComplete();
                });
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
