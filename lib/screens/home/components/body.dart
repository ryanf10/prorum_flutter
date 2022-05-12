import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final int currentTabIndex;
  const Body({
    Key? key,
    required this.currentTabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentTabIndex == 0 ? Text('Category') : Text('Feed');
  }
}
