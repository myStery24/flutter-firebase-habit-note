import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';

List<Widget> onboardScreenData(int numOfPages, screenContent) {
  List<Widget> list = [];

  for (int i = 0; i < numOfPages; i++) {
    try {
      list.add(_getScreenData(screenContent[i], i));
    } catch (e) {
      // print("Please provide enough content for all screens");
    }
  }
  return list;
}

Widget _getScreenData(Map<String, String> screenContent, i) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Column(
      // Align the heading and body text to the left
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Image(
            image: AssetImage(
              screenContent["scr ${i + 1} image"].toString(),
            ),
            height: getProportionateScreenHeight(300),
            width: getProportionateScreenWidth(270),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          screenContent["scr ${i + 1} heading"].toString(),
          style: GoogleFonts.lato(
            color: appStore.isDarkMode ? AppColors.kTextWhite : AppColors.kTextBlack,
            fontSize: 24.0,
            fontWeight: TextFontWeight.medium,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 1.0),
        Text(
          screenContent["scr ${i + 1} body text"].toString(),
          style: GoogleFonts.lato(
            color: appStore.isDarkMode ? AppColors.kTextWhite : AppColors.kTextBlack,
            fontSize: 18.0,
            fontWeight: TextFontWeight.regular,
            height: 1.0,
          ),
        ),
      ],
    ),
  );
}
