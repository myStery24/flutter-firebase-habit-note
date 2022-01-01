import 'package:flutter/material.dart';
import 'package:mighty_notes/utils/Colors.dart';

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      appBar: AppBar(
        title: Text('Terms of Use'),
      ),
    );
  }
}
