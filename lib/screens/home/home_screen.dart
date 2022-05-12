import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/screens/home/components/left_drawer.dart';
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
      drawer: const LeftDrawer(),
    );
  }
}

