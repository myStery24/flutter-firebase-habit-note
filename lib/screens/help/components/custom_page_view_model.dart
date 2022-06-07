import 'package:flutter/material.dart';
import 'package:habit_note/configs/constants.dart';

import '../../../configs/colors.dart';
import '../../../main.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.fontWeight,
      required this.image})
      : super(key: key);

  final String title;
  final String subtitle;
  final FontWeight fontWeight; // FontWeight.w700
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// Title
          Text(
            title,
            style: TextStyle(
                color: appStore.isDarkMode
                    ? AppColors.kTextWhite
                    : AppColors.kTextBlack,
                fontSize: 30,
                fontWeight: fontWeight),
          ),
          SizedBox(height: smallSpacer),

          /// Image
          Image.asset(image,
              fit: BoxFit.scaleDown,
              width: double.infinity,
              alignment: Alignment.center),
          SizedBox(height: smallSpacer),

          /// Description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              subtitle,
              style: TextStyle(
                  color: appStore.isDarkMode
                      ? AppColors.kTextWhite
                      : AppColors.kTextBlack,
                  fontSize: 18,
                  fontWeight: TextFontWeight.regular),
            ),
          ),
          SizedBox(height: spacer),
        ],
      ),
    );
  }
}
