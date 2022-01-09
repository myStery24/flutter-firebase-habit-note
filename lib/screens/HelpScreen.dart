import 'package:flutter/material.dart';
import 'package:habit_note/utils/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Center(
        child: Text(
          'Todo: User Guide \n[Notes, OCR, How to reset password]',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
