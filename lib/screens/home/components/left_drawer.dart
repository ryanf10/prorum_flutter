import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/circle_image.dart';
import 'package:prorum_flutter/components/dialog_box.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/screens/profile/profile_screen.dart';
import 'package:prorum_flutter/screens/welcome/welcome_screen.dart';
import 'package:prorum_flutter/session.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            child: DrawerHeader(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1.0)),
              ),
              child: Column(
                children: [
                  CircleImage(
                    width: 64,
                    height: 64,
                    image: Session.user!.base64Avatar != null
                        ? Image.memory(
                                base64Decode(Session.user!.base64Avatar!))
                            .image
                        : Image.asset("assets/images/avatar.jpg").image,
                  ),
                  // const Icon(Icons.person),
                  const Padding(padding: EdgeInsets.only(top: 17.0)),
                  Text(Session.user!.username),
                  Text(Session.user!.email!),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const ProfileScreen();
                  },
                ),
              ).whenComplete(() => Navigator.pop(context));
            },
          ),
          ListTile(
            iconColor: kPrimaryColor,
            textColor: kPrimaryColor,
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () {
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
          )
        ],
      ),
    );
  }
}
