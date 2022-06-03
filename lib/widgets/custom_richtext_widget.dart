import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';

class CustomRichTextWidget extends StatelessWidget {
  const CustomRichTextWidget({
    Key? key,
    required this.primaryText,
    required this.secondaryText,
    this.color = AppColors.kTextBlack,
    this.primaryFontSize = 30.0,
    this.secondaryFontSize = 12.0,
    this.fontWeight = TextFontWeight.regular,
  }) : super(key: key);

  final String primaryText;
  final String secondaryText;
  final Color color;
  final double primaryFontSize;
  final double secondaryFontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: primaryText,
            style: GoogleFonts.fugazOne(
              color: color,
              fontSize: primaryFontSize,
              fontWeight: fontWeight,
            ),
          ),
          TextSpan(
            text: secondaryText,
            style: GoogleFonts.lato(
              color: color,
              fontSize: secondaryFontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
