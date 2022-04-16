import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/screens/password/forgot_password_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';

class ResetAccountPasswordWidget extends StatelessWidget {
  const ResetAccountPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: "Alternatively, you can reset through an ",
          style: GoogleFonts.lato(
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kTextWhite
                : AppColors.kTextBlack,
            fontWeight: TextFontWeight.regular,
          ),
          children: [
            TextSpan(
              text: 'email link',
              style: GoogleFonts.lato(
                color: getBoolAsync(IS_DARK_MODE)
                    ? AppColors.kHabitOrange
                    : AppColors.kTextBlack,
                fontSize: 16.0,
                fontWeight: TextFontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ForgotPasswordScreen().launch(context);
                },
            ),
            TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}
