import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prorum_flutter/components/dialog_box.dart';
import 'package:prorum_flutter/components/rounded_dropdown_button.dart';
import 'package:prorum_flutter/screens/post/components/image_picker_button.dart';
import 'package:prorum_flutter/components/rounded_rectangle_input_field.dart';
import 'package:prorum_flutter/components/rounded_rectangle_multiline_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/category.dart';

import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  final int? defaultCategory;
  const CreatePostScreen({
    Key? key,
    this.defaultCategory,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? title, description, categoryId;
  File? image;
  String? filename;
  List<Category> categories = [];
  List<DropdownMenuItem<String>> items = [];
  bool isLoading = true;
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

  submitPost() async {
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
    } else if(!isSubmitted){
      setState(() {
        isSubmitted = true;
      });
      var request =
          http.MultipartRequest('POST', Uri.parse(baseApiUrl + '/forum/posts'));
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

      var res = await request.send();
      Navigator.pop(this.context);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future getCategories() async {
    final response = await FetchApi.get(baseApiUrl + '/forum/categories');

    final body = jsonDecode(response.body);
    List<Category> temp = [];
    List<DropdownMenuItem<String>> tempDropDown = [];
    for (int i = 0; i < body['data'].length; i++) {
      temp.add(Category.fromJson(body['data'][i]));
    }

    int? tempDefaultCategory = widget.defaultCategory;
    tempDropDown = temp.map<DropdownMenuItem<String>>((Category item) {
      tempDefaultCategory ??= item.categoryId;
      return DropdownMenuItem<String>(
          value: item.categoryId.toString(), child: Text(item.name));
    }).toList();
    setState(() {
      categories = temp;
      items = tempDropDown;
      isLoading = false;
      categoryId = tempDefaultCategory.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: const Text(
          'Form',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: submitPost,
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
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
                          controller: null,
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
                          controller: null,
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
