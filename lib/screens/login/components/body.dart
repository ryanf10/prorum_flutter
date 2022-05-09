import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/already_have_an_account_check.dart';
import 'package:prorum_flutter/components/rounded_button.dart';
import 'package:prorum_flutter/components/rounded_input_field.dart';
import 'package:prorum_flutter/components/rounded_password_field.dart';
import 'package:prorum_flutter/screens/login/components/background.dart';
import 'package:prorum_flutter/screens/signup/signup_screen.dart';

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
                  text: "LOGIN",
                  press: () {
                    String? msg;
                    if (email == null || email == '') {
                      msg = 'Please enter your email';
                      setState(() {
                        errorEmail = true;
                      });
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email!)) {
                          msg = "Please enter a valid email";
                    } else if (password == null || password == '') {
                      msg = 'Please enter your password';
                      setState(() {
                        errorPassword = true;
                      });
                    } else if (password!.length < 6){
                      msg = 'Password minimum length is 6';
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(msg ?? ""),
                        );
                      },
                    );
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
