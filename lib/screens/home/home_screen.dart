import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/screens/welcome/welcome_screen.dart';
import 'package:prorum_flutter/session.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
      ),
      body: const Text('Home'),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: kPrimaryLightColor, width: 2.0)),
              ),
              child: Text('Drawer Header'),
            ),
            Row(
              children: [
                TextButton.icon(
                  label: const Text('Signout'),
                  icon: const Icon(Icons.logout),
                  style: TextButton.styleFrom(
                    primary: kPrimaryColor
                  ),
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
          ],
        ),
      ),
    );
  }
}
