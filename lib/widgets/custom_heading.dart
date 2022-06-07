import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/configs/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs/colors.dart';

/// Used in Help screen
class CustomHeading extends StatelessWidget {
  const CustomHeading({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.color,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            color: color,
            fontSize: 25,
            fontWeight: TextFontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          subTitle,
          style: GoogleFonts.lato(
            color: color,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}

/// Screen header
/// Used in Labels and Ocr screen
class CustomInfoHeader extends StatelessWidget {
  final String? title;

  final IconData? icon;

  const CustomInfoHeader({Key? key, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              icon: Icon(
                icon,
                color: getBoolAsync(IS_DARK_MODE)
                    ? AppColors.kHabitOrange
                    : AppColors.kHabitDark,
              ),
              onPressed: null),
          Text(
            title!,
            style: GoogleFonts.lato(
              fontSize: 18.0,
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kTextWhite
                  : AppColors.kTextBlack,
              fontWeight: TextFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }
}
