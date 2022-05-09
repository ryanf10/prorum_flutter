import 'package:flutter/material.dart';
import 'package:prorum_flutter/components/text_field_container.dart';
import 'package:prorum_flutter/constant.dart';

class RoundedPasswordField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool isError;

  const RoundedPasswordField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.isError,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: isObsecure,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            hintText: widget.hintText,
            icon: const Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObsecure ? Icons.visibility : Icons.visibility_off ,
                color: kPrimaryLightColor,              
              ),
              onPressed: () {
                setState(() {
                  isObsecure = !isObsecure;
                });
              },
            ),
            border: InputBorder.none),
      ),
      isError: widget.isError,
    );
  }
}
