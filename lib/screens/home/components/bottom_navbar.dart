import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';

class BottomNavbar extends StatelessWidget {
  final int currentTabIndex;
  final Function(int) onTap;
  const BottomNavbar({
    Key? key,
    required this.currentTabIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: kPrimaryColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.cases_sharp),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Feed',
        ),
      ],
      currentIndex: currentTabIndex,
      onTap: onTap,
    );
  }
}
