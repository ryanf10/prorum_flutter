import 'package:flutter/material.dart';
import 'package:prorum_flutter/models/category.dart';

class RoundedDropdownButton extends StatelessWidget {
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final void Function(String?) onChanged;
  const RoundedDropdownButton({
    Key? key,
    required this.items,
    this.value,
    required this.onChanged,
  }) : super(key: key);

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
          border: Border.all(width: 1.0, color: Colors.grey[400]!)),
      child: DropdownButton(
        value: value,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
