import 'package:flutter/material.dart';
import 'package:habit_note/utils/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Text('Application information goes here'),
    );
  }
}
