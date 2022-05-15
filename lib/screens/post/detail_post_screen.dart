import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/circle_image.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/detail_post.dart';
import 'package:prorum_flutter/screens/post/edit_post_screen.dart';
import 'package:prorum_flutter/screens/post/preview_image_screen.dart';
import 'package:prorum_flutter/session.dart';

class DetailPostScreen extends StatefulWidget {
  final int postId;
  const DetailPostScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  bool isLoading = true;
  DetailPost? detailPost;
  String? base64Image;

  @override
  void initState() {
    super.initState();
    getPost();
  }

  getPost() async {
    final response = await FetchApi.get(
        baseApiUrl + "/forum/posts/" + widget.postId.toString());
    final body = jsonDecode(response.body);
    print(body);

    final responseImage = await FetchApi.get(
        baseApiUrl + "/forum/posts/" + widget.postId.toString() + "/image");

    final bodyImage = jsonDecode(responseImage.body);

    if (mounted) {
      setState(() {
        detailPost = DetailPost.fromJson(body['data']);
        base64Image = bodyImage['data'];
        isLoading = false;
      });
    }
  }

  Future refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: const Text(
          'Post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: !isLoading
            ? detailPost!.user.userId == Session.user!.userId
                ? [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return EditPostScreen(
                                  detailPost: detailPost!,
                                  base64Image: base64Image,
                                );
                              },
                            ),
                          ).whenComplete(() {
                            setState(() {
                              isLoading = true;
                            });
                            getPost();
                          });
                        },
                        icon: Icon(Icons.edit)),
                  ]
                : []
            : [],
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: kPrimaryColor,
        child: !isLoading
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                      child: Text(
                        detailPost!.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                      child: Text(detailPost!.description),
                    ),
                    base64Image != null
                        ? GestureDetector(
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Image.memory(
                                base64Decode(base64Image!),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return PreviewImageScreen(
                                        base64Image: base64Image!);
                                  },
                                ),
                              );
                            },
                          )
                        : const Text(''),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 10.0,
                      ),
                      child: Text(
                        'Published on',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Text(DateFormat.yMMMMd('en_US')
                          .add_jm()
                          .format(detailPost!.createdAt.toLocal())),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 10.0,
                      ),
                      child: Text(
                        'Author',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CircleImage(
                        width: 36,
                        height: 36,
                        image: Image.asset('assets/images/avatar.jpg').image,
                      ),
                      title: Text(detailPost!.user.username),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),                    
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              ),
      ),
    );
  }
}