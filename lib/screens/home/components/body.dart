import 'package:flutter/material.dart';
import 'package:prorum_flutter/screens/home/components/feed_tab.dart';

class Body extends StatelessWidget {
  final int currentTabIndex;
  const Body({
    Key? key,
    required this.currentTabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentTabIndex == 0 ? const Text('Category') : const FeedTab();
  }
}
