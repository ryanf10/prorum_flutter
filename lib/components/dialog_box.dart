import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';

class DialogBox extends StatelessWidget {
  final Widget content;
  const DialogBox({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: [
        ElevatedButton(
          child: const Text('Dismiss'),
          onPressed: () {
            Navigator.pop(
              context,
              true,
            );
          },
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
          ),
        )
      ],
    );
  }
}
