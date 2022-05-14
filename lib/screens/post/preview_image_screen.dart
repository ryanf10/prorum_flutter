import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImageScreen extends StatelessWidget {
  final String base64Image;
  const PreviewImageScreen({
    Key? key,
    required this.base64Image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: Image.memory(
        base64Decode(base64Image),
        width: double.infinity,
        height: double.infinity,
      ).image,
    );
  }
}
