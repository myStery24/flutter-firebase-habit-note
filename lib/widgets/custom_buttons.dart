import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';
import '../main.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 150.0,
    this.height = 50.0,
    this.elevation = 8.0,
    this.borderRadius = 30.0,
    this.color = AppColors.kHabitOrange,
    this.fontSize = 18.0,
    this.fontWeight = TextFontWeight.bold,
    this.textColor = AppColors.kTextWhite,
  }) : super(key: key);

  /// Button
  final String text;
  final VoidCallback onPressed;

  /// Button style
  final double width;
  final double height;
  final double elevation;
  final double borderRadius;
  final Color color;

  /// Button text style
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      minWidth: MediaQuery.of(context).size.width,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      height: height,
      color: color,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
            fontSize: fontSize, fontWeight: fontWeight, color: textColor),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  const CustomButton2({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 120.0,
    this.height = 60.0,
    this.borderRadius = 20.0,
    this.color = AppColors.kHabitOrange,
    this.fontSize = 18.0,
    this.fontWeight = TextFontWeight.bold,
    this.textColor = AppColors.kTextWhite,
  }) : super(key: key);

  /// Button
  final String text;
  final VoidCallback onPressed;

  /// Button style
  final double width;
  final double height;
  final double borderRadius;
  final Color color;

  /// Button text style
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: height,
      minWidth: width,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
            fontSize: fontSize, fontWeight: fontWeight, color: textColor),
      ),
    );
  }
}

class CustomSkipButton extends StatelessWidget {
  const CustomSkipButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppColors.kTextWhite,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              /// Top shadow
              BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(-3, -3),
                  color: appStore.isDarkMode
                      ? AppColors.kHabitOrange.withOpacity(0.1)
                      : AppColors.kHabitDark.withOpacity(0.1)),

              /// Bottom shadow
              BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(3, 3),
                  color: appStore.isDarkMode
                      ? AppColors.kHabitOrange.withOpacity(0.1)
                      : AppColors.kHabitDark.withOpacity(0.1)),
            ]),
        child: Text('SKIP', style: TextStyle(color: AppColors.kTextBlack)));
  }
}

class CustomNextButton extends StatelessWidget {
  const CustomNextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppColors.kTextWhite,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              /// Top shadow
              BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(-3, -3),
                  color: appStore.isDarkMode
                      ? AppColors.kHabitOrange.withOpacity(0.1)
                      : AppColors.kHabitDark.withOpacity(0.1)),

              /// Bottom shadow
              BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(3, 3),
                  color: appStore.isDarkMode
                      ? AppColors.kHabitOrange.withOpacity(0.1)
                      : AppColors.kHabitDark.withOpacity(0.1)),
            ]),
        child: Text('NEXT', style: TextStyle(color: AppColors.kTextBlack)));
  }
}

class CustomDoneButton extends StatelessWidget {
  const CustomDoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppColors.kHabitOrange,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              /// Top shadow
              BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(-3, -3),
                  color: appStore.isDarkMode
                      ? AppColors.kHabitOrange.withOpacity(0.1)
                      : AppColors.kHabitDark.withOpacity(0.1)),

              /// Bottom shadow
              BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(3, 3),
                  color: appStore.isDarkMode
                      ? AppColors.kHabitOrange.withOpacity(0.1)
                      : AppColors.kHabitDark.withOpacity(0.1)),
            ]),
        child: Text('DONE',
            style: TextStyle(color: AppColors.kTextBlack, fontSize: 18)));
  }
}
