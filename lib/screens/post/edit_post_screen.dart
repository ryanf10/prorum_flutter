import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prorum_flutter/components/dialog_box.dart';
import 'package:prorum_flutter/components/rounded_dropdown_button.dart';
import 'package:prorum_flutter/components/rounded_rectangle_input_field.dart';
import 'package:prorum_flutter/components/rounded_rectangle_multiline_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/category.dart';
import 'package:prorum_flutter/models/detail_post.dart';
import 'package:prorum_flutter/screens/post/components/delete_button.dart';
import 'package:prorum_flutter/screens/post/components/image_picker_button.dart';
import 'package:prorum_flutter/session.dart';

class EditPostScreen extends StatefulWidget {
  final DetailPost detailPost;
  final String? base64Image;
  const EditPostScreen({
    Key? key,
    required this.detailPost,
    this.base64Image,
  }) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  String? title, description, categoryId;
  File? image;
  String? filename;
  List<Category> categories = [];
  List<DropdownMenuItem<String>> items = [];
  bool isLoading = true;
  bool canDelete = false;
  bool isErrorTitle = false;
  bool isErrorDescription = false;
  bool isSubmitted = false;

  clearImage() {
    setState(() {
      image = null;
    });
  }

  Future imagePicker() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage == null) {
      return;
    }

    setState(() {
      image = File(selectedImage.path);
      filename = basename(image!.path);
    });
  }

  updatePost() async {
    if (title == '' || title == null) {
      setState(() {
        isErrorTitle = true;
      });

      showDialog(
        context: this.context,
        builder: (context) {
          return const DialogBox(content: Text('Title cannot be empty'));
        },
      );
    } else if (description == '' || description == null) {
      setState(() {
        isErrorDescription = true;
      });

      showDialog(
        context: this.context,
        builder: (context) {
          return const DialogBox(content: Text('Description cannot be empty'));
        },
      );
    } else if (!isSubmitted) {
      setState(() {
        isSubmitted = true;
      });
      var request = http.MultipartRequest(
          'PATCH',
          Uri.parse(baseApiUrl +
              '/forum/posts/' +
              widget.detailPost.postId.toString()));
      request.headers.addAll(FetchApi.headers);
      request.fields['title'] = title!;
      request.fields['description'] = description!;
      request.fields['category_id'] = categoryId!;

      if (image != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          await image!.readAsBytes(),
          filename: filename,
        ));
      }

      await request.send();
      Navigator.pop(this.context);
    }
  }

  @override
  void initState() {
    super.initState();
    title = widget.detailPost.title;
    description = widget.detailPost.description;
    categoryId = widget.detailPost.category.categoryId.toString();
    titleController.text = title!;
    descriptionController.text = description!;
    categoryIdController.text = categoryId!;

    DateTime now = DateTime.now().toUtc();
    if (now.isBefore(widget.detailPost.deleteableBefore) &&
        Session.user!.userId == widget.detailPost.user.userId) {
      setState(() {
        canDelete = true;
      });
    }

    if (widget.base64Image != null) {
      convertImageToFile();
    }
    getCategories();
  }

  Future convertImageToFile() async {
    var rng = Random();

    Directory tempDir = await getTemporaryDirectory();

    String tempPath = tempDir.path;

    File file = File(tempPath + (rng.nextInt(100)).toString());
    await file.writeAsBytes(base64Decode(widget.base64Image!));
    setState(() {
      image = file;
      filename = 'post-${widget.detailPost.postId}.jpg';
    });
  }

  Future getCategories() async {
    final response = await FetchApi.get(baseApiUrl + '/forum/categories');

    final body = jsonDecode(response.body);
    List<Category> temp = [];
    List<DropdownMenuItem<String>> tempDropDown = [];
    for (int i = 0; i < body['data'].length; i++) {
      temp.add(Category.fromJson(body['data'][i]));
    }

    tempDropDown = temp.map<DropdownMenuItem<String>>((Category item) {
      return DropdownMenuItem<String>(
          value: item.categoryId.toString(), child: Text(item.name));
    }).toList();
    setState(() {
      categories = temp;
      items = tempDropDown;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: const Text(
          'Edit Post',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: updatePost,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: !isLoading
          ? SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                        child: Text(
                          'Title',
                          style: TextStyle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: RoundedRectangleInputField(
                          isError: isErrorTitle,
                          hintText: "",
                          onChanged: (value) {
                            setState(() {
                              isErrorTitle = value == '' ? true : false;
                              title = value;
                            });
                          },
                          icon: null,
                          controller: titleController,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                        child: Text(
                          'Description',
                          style: TextStyle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: RoundedRectangleMultilineInputField(
                          isError: isErrorDescription,
                          hintText: "",
                          onChanged: (value) {
                            setState(() {
                              isErrorDescription = value == '' ? true : false;
                              description = value;
                            });
                          },
                          icon: null,
                          controller: descriptionController,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                        child: Text(
                          'Image',
                          style: TextStyle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: ImagePickerButton(
                          onPressed: () => imagePicker(),
                          label: image == null ? null : filename,
                          clearImage: () => clearImage(),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                        child: Text(
                          'Category',
                          style: TextStyle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: RoundedDropdownButton(
                          value: categoryId,
                          items: items,
                          onChanged: (String? value) {
                            setState(() {
                              categoryId = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                        child: canDelete
                            ? DeleteButton(onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Are you sure want to delete this item?'),
                                        content: const Text(
                                            'This action cannot be undone'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final response =
                                                  await FetchApi.delete(
                                                      baseApiUrl +
                                                          "/forum/posts/" +
                                                          widget
                                                              .detailPost.postId
                                                              .toString(),
                                                      null);
                                              final body =
                                                  jsonDecode(response.body);
                                              Navigator.of(context).pop();
                                              if (body['statusCode'] == 200) {
                                                int count = 0;
                                                Navigator.popUntil(
                                                  context,
                                                  (route) {
                                                    count++;
                                                    return count == 3;
                                                  },
                                                );
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return DialogBox(
                                                          content: Text(
                                                              body['message']));
                                                    });
                                              }
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              })
                            : const Text(''),
                      ),
                    ],
                  ),
                ),
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
