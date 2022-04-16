import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';
import '../configs/routes.dart';

class UserAgreementWidget extends StatelessWidget {
  const UserAgreementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text:
          "By clicking the “CREATE ACCOUNT” button, you agree to our ",
          style: GoogleFonts.lato(
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kTextWhite
                : AppColors.kTextBlack,
            fontSize: 16.0,
            fontWeight: TextFontWeight.regular,
          ),
          children: [
            TextSpan(
              text: 'Terms of Use ',
              style: GoogleFonts.lato(
                color: getBoolAsync(IS_DARK_MODE)
                    ? AppColors.kHabitOrange
                    : AppColors.kTextBlack,
                fontSize: 16.0,
                fontWeight: TextFontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, AppRoutes().termsScreen);
                },
            ),
            TextSpan(text: 'and '),
            TextSpan(
                text: 'Privacy Policy',
                style: GoogleFonts.lato(
                  color: getBoolAsync(IS_DARK_MODE)
                      ? AppColors.kHabitOrange
                      : AppColors.kTextBlack,
                  fontSize: 16.0,
                  fontWeight: TextFontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(context, AppRoutes().privacyScreen);
                  }),
          ],
        ),
      ),
    );
  }
}
