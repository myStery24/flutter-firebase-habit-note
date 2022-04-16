import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/constants.dart';
import '../../../main.dart';

class CustomDecoBox extends StatelessWidget {
  const CustomDecoBox({
    Key? key,
    required this.margin,
    required this.padding,
    this.borderRadius = 12.0,
    this.elevation = 5.0,
    required this.lightModeColor,
    required this.lightModeShadowColor,
    required this.textColor,
    required this.text,
    this.fontSize = 18.0,
    this.fontWeight = TextFontWeight.medium,
    required this.darkModeColor,
    required this.darkModeShadowColor,
  }) : super(key: key);

  /// Info box style
  final EdgeInsets margin, padding;
  final double borderRadius;
  final double elevation;
  final Color textColor;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  /// Light mode style
  final Color lightModeColor;
  final Color lightModeShadowColor;

  /// Dark mode style
  final Color darkModeColor;
  final Color darkModeShadowColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: appStore.isDarkMode ? darkModeColor : lightModeColor,
        shadowColor: appStore.isDarkMode ? darkModeShadowColor : lightModeShadowColor,
        elevation: elevation,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    text,
                    style: GoogleFonts.lato(
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: fontWeight),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
