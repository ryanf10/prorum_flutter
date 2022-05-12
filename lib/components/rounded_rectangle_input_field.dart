import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';

class RoundedRectangleInputField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final IconData icon;

  const RoundedRectangleInputField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: size.width * 0.95,
      decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: Colors.grey[400]!)),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[500]),
            hintText: hintText,
            icon: Icon(
              icon,
              color: Colors.black,
            )),
        onChanged: onChanged,
      ),
    );
  }
}
