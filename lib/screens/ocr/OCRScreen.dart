import 'package:flutter/material.dart';
import 'package:mighty_notes/utils/Colors.dart';

class OCRScreen extends StatelessWidget {
  const OCRScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      appBar: AppBar(
        title: Text('Image to Text (OCR)'),
      ),
      body: Center(
        child: Text(
          'Todo: Text Recognition',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
