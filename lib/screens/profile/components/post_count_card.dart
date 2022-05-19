import 'package:flutter/material.dart';
import 'package:prorum_flutter/screens/post/post_by_user_screen.dart';

class PostCountCard extends StatelessWidget {
  final String title;
  final int postCount;
  final int userId;
  const PostCountCard({
    Key? key,
    required this.postCount,
    required this.title,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
        child: ListTile(
          title: Text(title),
          subtitle: postCount > 1
              ? Text('$postCount posts')
              : Text('$postCount post'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PostByUserScreen(
                    userId: userId,
                    title: title,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
