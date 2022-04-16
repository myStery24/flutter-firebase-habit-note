import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';

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
