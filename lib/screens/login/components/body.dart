import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/already_have_an_account_check.dart';
import 'package:prorum_flutter/components/dialog_box.dart';
import 'package:prorum_flutter/components/rounded_button.dart';
import 'package:prorum_flutter/components/rounded_input_field.dart';
import 'package:prorum_flutter/components/rounded_password_field.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/screens/home/home_screen.dart';
import 'package:prorum_flutter/screens/login/components/background.dart';
import 'package:prorum_flutter/screens/signup/signup_screen.dart';
import 'package:prorum_flutter/session.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? email, password;
  bool errorEmail = false;
  bool errorPassword = false;
  bool isDisabledLogin = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'LOGIN',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Image.asset(
              "assets/icon/ic_launcher_round.png",
              height: size.height * 0.35,
            ),
            Column(
              children: [
                RoundedInputField(
                  hintText: "Your Email",
                  isError: errorEmail,
                  icon: Icons.person,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      errorEmail = email! != '' ? false : true;
                    });
                  },
                ),
                RoundedPasswordField(
                  hintText: "Password",
                  isError: errorPassword,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                      errorPassword = password!.length >= 6 ? false : true;
                    });
                  },
                ),
                RoundedButton(
                  isDisabled: isDisabledLogin,
                  text: "LOGIN",
                  press: () async {
                    if (!isDisabledLogin) {
                      String? msg;
                      bool success = false;
                      if (email == null || email == '') {
                        msg = 'Please enter your email';
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
                      } else if (password == null || password == '') {
                        msg = 'Please enter your password';
                        setState(() {
                          errorPassword = true;
                        });
                      } else if (password!.length < 6) {
                        msg = 'Password minimum length is 6';
                        setState(() {
                          errorPassword = true;
                        });
                      } else {
                        setState(() {
                          isDisabledLogin = true;
                        });
                        final response = await FetchApi.post(
                          baseApiUrl + "/auth/login",
                          {
                            'email': email,
                            'password': password,
                          },
                        );

                        var res = jsonDecode(response.body);

                        if (res['statusCode'] == 200) {
                          msg = "Success";
                          success = true;
                          Session.saveCookie(response);
                          Session.getUser();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const HomeScreen();
                              },
                            ),
                            (route) => false,
                          );
                        } else if (res['statusCode'] == 401) {
                          msg = "Invalid credentials";
                          setState(() {
                            errorEmail = true;
                            errorPassword = true;
                          });
                        }
                      }
                      if (!success) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DialogBox(content: Text(msg ?? ''));
                          },
                        );
                        setState(() {
                          isDisabledLogin = false;
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const DialogBox(content: Text('Please wait'));
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SignUpScreen();
                    },
                  ),
                );
              },
              login: true,
            )
          ],
        ),
      ),
    );
  }
}
