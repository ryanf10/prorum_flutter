import 'package:flutter/material.dart';

class ImagePickerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;
  final VoidCallback clearImage;
  const ImagePickerButton({
    Key? key,
    required this.onPressed,
    this.label,
    required this.clearImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      width: size.width * 0.95,
      decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: Colors.grey[400]!)),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.image,
                  color: Colors.grey,
                ),
                label: Text(
                  label ?? 'Choose an image',
                  style: TextStyle(
                    color: label != null ? Colors.black : Colors.grey,
                  ),
                ),
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  alignment: Alignment.topLeft,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: label != null ? ([
              IconButton(onPressed: clearImage, icon: const Icon(Icons.close)),
            ]) : [],
          ),
        ],
      ),
    );
  }
}
