import 'package:flutter/material.dart';
import 'package:prorum_flutter/models/post.dart';
import 'package:prorum_flutter/screens/post/detail_post_screen.dart';

class ListPosts extends StatelessWidget {
  final List<Post> posts;
  final VoidCallback whenComplete;
  const ListPosts({
    Key? key,
    required this.posts,
    required this.whenComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(posts[index].category.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DetailPostScreen(postId: posts[index].postId);
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
