import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/circle_image.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/user.dart';
import 'package:prorum_flutter/screens/profile/components/post_count_card.dart';
import 'package:prorum_flutter/screens/profile/components/sign_out_button.dart';

class UserInfoScreen extends StatefulWidget {
  final int userId;
  const UserInfoScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String base64Image = '';
  int postCount = 0;
  bool isLoading = true;
  User? user;

  getInfo() async {
    final res = await FetchApi.get(baseApiUrl + "/users/info/${widget.userId}");
    final body = jsonDecode(res.body);

    final resAvatar =
        await FetchApi.get(baseApiUrl + "/users/avatar/${widget.userId}");
    final bodyAvatar = jsonDecode(resAvatar.body);

    if (body['statusCode'] == 200 && bodyAvatar['statusCode'] == 200) {
      setState(() {
        postCount = int.parse(body['data']['user']['posts_count']);
        user = User.fromJson(body['data']['user']);
        base64Image = bodyAvatar['data'] ?? '';
        isLoading = false;
      });
      print(base64Image);
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
      ),
      body: !isLoading
          ? SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: CircleImage(
                      width: 128,
                      height: 128,
                      image: base64Image != ''
                          ? Image.memory(base64Decode(base64Image)).image
                          : Image.asset('assets/images/avatar.jpg').image,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      user!.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PostCountCard(
                    postCount: postCount,
                    title: "Posts",
                    userId: widget.userId,
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
    );
  }
}
