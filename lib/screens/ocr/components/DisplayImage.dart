import 'dart:io';

import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String? path;
  const DisplayImage(this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Image.file(
        File(path!),
        width: 350,
        height: 400,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}