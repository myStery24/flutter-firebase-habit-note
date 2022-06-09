import 'package:flutter/material.dart';
import 'package:habit_note/configs/constants.dart';
import 'package:nb_utils/nb_utils.dart';

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
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            15.height,

            /// Title
            Text(title,
                style: TextStyle(
                    color: appStore.isDarkMode
                        ? AppColors.kTextWhite
                        : AppColors.kTextBlack,
                    fontSize: 24,
                    fontWeight: fontWeight),
                textAlign: TextAlign.center),
            SizedBox(height: miniSpacer),

            /// Image
            Image.asset(image,
                fit: BoxFit.scaleDown,
                width: double.infinity,
                alignment: Alignment.center),
            SizedBox(height: miniSpacer),

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
            SizedBox(height: miniSpacer),
          ],
        ),
      ),
    );
  }
}
