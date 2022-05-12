import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/screens/home/components/body.dart';
import 'package:prorum_flutter/screens/home/components/bottom_navbar.dart';
import 'package:prorum_flutter/screens/home/components/left_drawer.dart';
import 'package:prorum_flutter/screens/welcome/welcome_screen.dart';
import 'package:prorum_flutter/session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        title: currentTabIndex == 0
            ? const Text(
                'Category',
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                'Feed',
                style: TextStyle(color: Colors.black),
              ),
        centerTitle: true,
      ),
      body: Body(currentTabIndex: currentTabIndex),
      drawer: const LeftDrawer(),
      bottomNavigationBar: BottomNavbar(
        currentTabIndex: currentTabIndex,
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
      ),
    );
  }
}
