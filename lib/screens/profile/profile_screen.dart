import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prorum_flutter/components/circle_image.dart';
import 'package:prorum_flutter/components/dialog_box.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/screens/welcome/welcome_screen.dart';
import 'package:prorum_flutter/session.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String base64Image = '';
  Future imagePickerFromGallery() async {
    Navigator.pop(this.context);
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage == null) {
      return;
    }

    File tempAvatar = File(selectedImage.path);
    await setAvatar(tempAvatar);
    final List<int> bytes = await tempAvatar.readAsBytes();
    final String tempBase64 = base64Encode(bytes);

    setState(() {
      base64Image = tempBase64;
    });
    Session.user!.base64Avatar = tempBase64;
  }

  Future imagePickerFromCamera() async {
    Navigator.pop(this.context);
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (selectedImage == null) {
      return;
    }

    File tempAvatar = File(selectedImage.path);
    await setAvatar(tempAvatar);
    final List<int> bytes = await tempAvatar.readAsBytes();
    final String tempBase64 = base64Encode(bytes);

    setState(() {
      base64Image = tempBase64;
    });
    Session.user!.base64Avatar = tempBase64;
  }

  setAvatar(File avatar) async {
    var request = http.MultipartRequest(
        'PATCH', Uri.parse(baseApiUrl + '/users/change-avatar'));
    request.headers.addAll(FetchApi.headers);

    if (avatar != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        await avatar.readAsBytes(),
        filename: basename(avatar.path),
      ));
    }

    var res = await request.send();
  }

  @override
  void initState() {
    super.initState();
    base64Image = Session.user!.base64Avatar ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GestureDetector(
                child: CircleImage(
                  width: 128,
                  height: 128,
                  image: base64Image != ''
                      ? Image.memory(base64Decode(base64Image)).image
                      : Image.asset('assets/images/avatar.jpg').image,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      Size size = MediaQuery.of(context).size;
                      return AlertDialog(
                        content: Container(
                          width: size.width * 0.9,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.photo,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Choose From Gallery',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: imagePickerFromGallery,
                                style: TextButton.styleFrom(
                                    alignment: Alignment.topLeft),
                              ),
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Choose From Camera',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: imagePickerFromCamera,
                                style: TextButton.styleFrom(
                                    alignment: Alignment.topLeft),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFFDFF5F5),
                          onPrimary: kPrimaryColor,
                          elevation: 0),
                      child: const Text('SIGN OUT'),
                      onPressed: () {
                        Session.destroyAll();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const WelcomeScreen();
                            },
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
