import 'package:flutter/material.dart';
import 'package:mighty_notes/utils/Colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      appBar: AppBar(
        title: Text('Me'),
      ),
      body: Center(
        child: Text(
          'Todo: Profile + \nApp settings [Dark mode, Reset password, About]',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
