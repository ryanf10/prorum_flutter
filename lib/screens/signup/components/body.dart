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
import 'package:prorum_flutter/screens/login/login_screen.dart';
import 'package:prorum_flutter/screens/signup/components/background.dart';
import 'package:prorum_flutter/session.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? email, username, password, confirmPassword;
  bool errorEmail = false;
  bool errorUsername = false;
  bool errorPassword = false;
  bool errorConfirmPassword = false;
  bool isDisabledSignUp = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'SIGNUP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  "assets/icon/ic_launcher_round.png",
                  height: size.height * 0.35,
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
                RoundedInputField(
                  hintText: "Username",
                  isError: errorUsername,
                  icon: Icons.person,
                  onChanged: (value) {
                    setState(() {
                      username = value;
                      errorUsername = username! != '' ? false : true;
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
                RoundedPasswordField(
                  hintText: "Confirm Password",
                  isError: errorConfirmPassword,
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                      errorConfirmPassword =
                          password! == confirmPassword! ? false : true;
                    });
                  },
                ),
                RoundedButton(
                  text: "SIGN UP",
                  isDisabled: isDisabledSignUp,
                  press: () async {
                    if (!isDisabledSignUp) {
                      String? msg;
                      bool success = false;

                      if (email == null || email == '') {
                        msg = 'Please enter your email';
                        setState(() {
                          errorEmail = true;
                        });
                      } else if (username == null || username == '') {
                        msg = 'Please enter your username';
                        setState(() {
                          errorUsername = true;
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
                      } else if (confirmPassword == null) {
                        msg = 'Please confirm your password';
                        setState(() {
                          errorConfirmPassword = true;
                        });
                      } else if (password != confirmPassword) {
                        msg = 'Password and confirm password does not match';
                        setState(() {
                          errorConfirmPassword = true;
                        });
                      } else {
                        setState(() {
                          isDisabledSignUp = true;
                        });
                        final response = await FetchApi.post(
                          baseApiUrl + "/auth/signup",
                          {
                            'email': email,
                            'username': username,
                            'password': password,
                          },
                        );
                        var res = jsonDecode(response.body);
                        if (res['statusCode'] == 409) {
                          msg = res['message'];
                          if (res['message'].contains('Email')) {
                            setState(() {
                              errorEmail = true;
                            });
                          } else if (res['message'].contains('Username')) {
                            setState(() {
                              errorUsername = true;
                            });
                          }
                        } else if (res['statusCode'] == 201) {
                          msg = "Success";
                          success = true;
                          Session.saveCookie(response);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const HomeScreen();
                              },
                            ),
                            (route) => false,
                          );
                        }
                        setState(() {
                          isDisabledSignUp = false;
                        });
                      }
                      if (!success) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DialogBox(
                              content: Text(msg ?? ''),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                )
              ]),
        ),
      ),
    );
  }
}
