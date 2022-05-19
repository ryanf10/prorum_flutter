import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/dialog_box.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';

class CreateCommentScreen extends StatefulWidget {
  final int postId;
  const CreateCommentScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<CreateCommentScreen> createState() => _CreateCommentScreenState();
}

class _CreateCommentScreenState extends State<CreateCommentScreen> {
  String? content;

  createComment() async {
    if (content == null || content == '') {
      showDialog(
        context: context,
        builder: (context) {
          return const DialogBox(content: Text('Please fill the comment'));
        },
      );
    } else {
      final response = await FetchApi.post(
        baseApiUrl + '/forum/comments',
        {'content': content, 'post_id': widget.postId.toString()},
      );

      final body = jsonDecode(response.body);

      if (body['statusCode'] == 201) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const DialogBox(content: Text('Please try again later'));
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: const Text('Comment'),
        actions: [
          IconButton(
            onPressed: createComment,
            icon: Transform.rotate(
              angle: -45 / 180 * math.pi,
              child: Icon(
                Icons.send,
                color: (content == null || content == '')
                    ? Colors.grey
                    : kPrimaryColor,
              ),
            ),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[500]),
              hintText: "Add a comment",
            ),
            onChanged: (value) {
              setState(() {
                content = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
