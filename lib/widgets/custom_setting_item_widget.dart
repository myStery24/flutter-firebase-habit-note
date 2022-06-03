import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';

class CustomSettingItemWidget extends StatelessWidget {
  const CustomSettingItemWidget({
    Key? key,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.semanticLabel,
    this.iconSize = 30.0,
    this.iconDarkTheme = AppColors.kHabitOrange,
    this.iconLightTheme = AppColors.kPrimaryVariantColorDark,
    required this.title,
    this.fontWeight = TextFontWeight.regular,
    this.titleDarkTheme = AppColors.kTextWhite,
    this.titleLightTheme = AppColors.kTextBlack,
    required this.onTap,
  }) : super(key: key);

  final IconData leadingIcon;
  final IconData trailingIcon;
  final String semanticLabel;
  final double iconSize;
  final iconDarkTheme;
  final iconLightTheme;

  final String title;
  final Color titleDarkTheme;
  final Color titleLightTheme;
  final FontWeight fontWeight;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          leadingIcon,
          semanticLabel: semanticLabel,
          size: iconSize,
          color: getBoolAsync(IS_DARK_MODE) ? iconDarkTheme : iconLightTheme,
        ),
        title: Text(
          title,
          style: GoogleFonts.lato(
              color:
                  getBoolAsync(IS_DARK_MODE) ? titleDarkTheme : titleLightTheme,
              fontWeight: fontWeight),
        ),
        trailing: Icon(trailingIcon,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark),
        onTap: onTap);
  }
}
