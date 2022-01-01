import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:mighty_notes/utils/Constants.dart';

class OnboardTitle extends StatelessWidget {
  const OnboardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10.0, left: 20.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "WELCOME TO\n",
                style: GoogleFonts.roboto(
                  fontSize: 18.0,
                  color: AppColors.kTextBlack,
                  fontWeight: TextFontWeight.light,
                ),
              ),
              TextSpan(
                text: "HaBIT Note",
                style: GoogleFonts.fugazOne(
                  color: AppColors.kTextBlack,
                  fontSize: 18.0,
                  fontWeight: TextFontWeight.regular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
