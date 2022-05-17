import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/circle_image.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/comment.dart';
import 'package:prorum_flutter/models/detail_post.dart';
import 'package:prorum_flutter/screens/post/create_comment_screen.dart';
import 'package:prorum_flutter/screens/post/edit_post_screen.dart';
import 'package:prorum_flutter/screens/post/post_by_user_screen.dart';
import 'package:prorum_flutter/screens/post/preview_image_screen.dart';
import 'package:prorum_flutter/screens/profile/profile_screen.dart';
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
  List<Comment> comments = [];
  Map<int, String> avatar = <int, String>{};

  @override
  void initState() {
    super.initState();
    getPost();
  }

  getPost() async {
    final response = await FetchApi.get(
        baseApiUrl + "/forum/posts/" + widget.postId.toString());
    final body = jsonDecode(response.body);

    List<Comment> tempComment = [];
    Map<int, String> tempAvatar = <int, String>{};
    tempAvatar[Session.user!.userId] = Session.user!.base64Avatar ?? '';
    if (body['statusCode'] != 200) {
      return;
    }
    for (int i = 0; i < body['data']['comments'].length; i++) {
      Comment comment = Comment.fromJson(body['data']['comments'][i]);
      tempComment.add(comment);

      if (!tempAvatar.containsKey(comment.user.userId)) {
        if (comment.user.userId != Session.user!.userId) {
          final tempResAvatar = await FetchApi.get(
              baseApiUrl + '/users/avatar/${comment.user.userId}');
          final String? tempBase64Avatar =
              jsonDecode(tempResAvatar.body)['data'];
          tempAvatar[comment.user.userId] = tempBase64Avatar ?? '';
        }
      }
    }

    final responseImage = await FetchApi.get(
        baseApiUrl + "/forum/posts/" + widget.postId.toString() + "/image");

    final bodyImage = jsonDecode(responseImage.body);

    if (mounted) {
      setState(() {
        detailPost = DetailPost.fromJson(body['data']);
        base64Image = bodyImage['data'];
        comments = tempComment;
        avatar = tempAvatar;
        isLoading = false;
      });
    }
  }

  Future refreshData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await getPost();
  }

  handleFavorite() async {
    if (detailPost!.isFavorited) {
      setState(() {
        detailPost!.isFavorited = false;
      });

      await FetchApi.delete(
          baseApiUrl + "/forum/favorites/" + detailPost!.postId.toString(),
          null);
    } else {
      setState(() {
        detailPost!.isFavorited = true;
      });

      await FetchApi.post(
          baseApiUrl + "/forum/favorites/" + detailPost!.postId.toString(),
          null);
    }
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
                            if (mounted) {
                              setState(() {
                                isLoading = true;
                              });
                              getPost();
                            }
                          });
                        },
                        icon: const Icon(Icons.edit)),
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
                        right: 10.0,
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
                        right: 10.0,
                      ),
                      child: Text(DateFormat.yMMMMd('en_US')
                          .add_jm()
                          .format(detailPost!.createdAt.toLocal())),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Favorite',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: handleFavorite,
                            icon: detailPost!.isFavorited
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                          )
                        ],
                      ),
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
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        left: 10.0,
                      ),
                      child: comments.isNotEmpty
                          ? Text('${comments.length} comments')
                          : const Text('No comments'),
                    ),
                    Column(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: comments.length,
                          primary: false,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 10.0),
                              child: SizedBox(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          child: CircleImage(
                                            width: 32,
                                            height: 32,
                                            image: avatar[comments[i]
                                                        .user
                                                        .userId] !=
                                                    ''
                                                ? Image.memory(base64Decode(
                                                        avatar[comments[i]
                                                            .user
                                                            .userId]!))
                                                    .image
                                                : Image.asset(
                                                        'assets/images/avatar.jpg')
                                                    .image,
                                          ),
                                          onTap: () {
                                            if (Session.user!.userId ==
                                                comments[i].user.userId) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return const ProfileScreen();
                                                  },
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                comments[i].user.username,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(comments[i].content)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 20.0),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            CircleImage(
                              width: 32,
                              height: 32,
                              image: Session.user!.base64Avatar != null
                                  ? Image.memory(base64Decode(
                                          Session.user!.base64Avatar!))
                                      .image
                                  : Image.asset('assets/images/avatar.jpg')
                                      .image,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Add comment...',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return CreateCommentScreen(
                                  postId: detailPost!.postId,
                                );
                              },
                            ),
                          ).whenComplete(() => refreshData());
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
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
