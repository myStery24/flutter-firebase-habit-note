import 'package:flutter/material.dart';
import 'package:mighty_notes/utils/Colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      //drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
    );
  }
}
