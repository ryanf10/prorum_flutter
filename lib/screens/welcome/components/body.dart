import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/rounded_button.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/screens/login/login_screen.dart';
import 'package:prorum_flutter/screens/signup/signup_screen.dart';
import 'package:prorum_flutter/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Welcome to Prorum",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Image.asset(
                'assets/icon/ic_launcher_round.png',
                height: size.height * 0.45,
              ),
              RoundedButton(
                text: "LOGIN",
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
              ),
              RoundedButton(
                text: "SIGN UP",
                color: kPrimaryLightColor,
                textColor: Colors.black,
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
              )
            ]),
      ),
    );
  }
}
