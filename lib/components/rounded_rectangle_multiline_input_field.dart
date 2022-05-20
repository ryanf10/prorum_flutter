import 'package:flutter/material.dart';

class RoundedRectangleMultilineInputField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final IconData? icon;
  final TextEditingController? controller;
  final bool isError;

  const RoundedRectangleMultilineInputField(
      {Key? key,
      required this.hintText,
      required this.onChanged,
      required this.icon,
      required this.controller,
      required this.isError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.grey[200]!,
        borderRadius: BorderRadius.circular(10.0),
        border: isError
            ? Border.all(width: 1.0, color: Colors.red)
            : Border.all(width: 1.0, color: Colors.grey[400]!),
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: hintText,
          icon: icon != null
              ? Icon(
                  icon,
                  color: Colors.black,
                )
              : null,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
