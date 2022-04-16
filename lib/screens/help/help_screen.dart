import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode
          ? AppColors.kScaffoldColorDark
          : AppColors.kScaffoldColor,
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
