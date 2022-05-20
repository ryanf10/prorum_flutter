import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  const FloatingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: kPrimaryColor,
      child: const Icon(Icons.add),
    );
  }
}
