import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/dialog_box.dart';
import 'package:prorum_flutter/components/rounded_button.dart';
import 'package:prorum_flutter/components/rounded_input_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/screens/reset_password/components/background.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? email;
  bool errorEmail = false;
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const Text(
                'RESET PASSWORD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              RoundedInputField(
                hintText: "Your Email",
                isError: errorEmail,
                icon: Icons.alternate_email_outlined,
                onChanged: (value) => {
                  setState(() {
                    email = value;
                    errorEmail = email! != '' ? false : true;
                  })
                },
              ),
              RoundedButton(
                  text: "Submit",
                  press: () async {
                    bool isSuccess = false;
                    String msg = '';
                    if (email == null || email == '') {
                      setState(() {
                        errorEmail = true;
                      });
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email!)) {
                      msg = "Please enter a valid email";
                      setState(() {
                        errorEmail = true;
                      });
                    } else {
                      final res = await FetchApi.post(
                        "$baseApiUrl/users/forgot-password",
                        {'email': email},
                      );

                      final body = jsonDecode(res.body);
                      if (body['statusCode'] == 200) {
                        setState(() {
                          isSuccess = true;
                        });
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const DialogBox(
                              content: Text("Please check your email"),
                            );
                          },
                        );
                      } else {
                        setState(() {
                          errorEmail = true;
                        });
                        msg = body['message'];
                      }
                    }
                    if (!isSuccess) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogBox(content: Text(msg));
                        },
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
