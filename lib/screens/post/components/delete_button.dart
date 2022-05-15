import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeleteButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      width: size.width * 0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: Colors.red)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            child: const Center(
              child: Text(
                'DELETE ITEM',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            onPressed: onPressed,
            style: TextButton.styleFrom(
              alignment: Alignment.topLeft,
              primary: Colors.red[200]!
            ),
          ),
        ],
      ),
    );
  }
}
