import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/screens/welcome/welcome_screen.dart';
import 'package:prorum_flutter/session.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFDFF5F5),
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
    );
  }
}