import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      appBar: AppBar(
        title: Text(AppStrings.helpScreen,
          style: GoogleFonts.fugazOne(),
        ),
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
