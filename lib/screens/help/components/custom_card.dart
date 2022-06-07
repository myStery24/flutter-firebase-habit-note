import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';

class CustomBannerCard extends StatelessWidget {
  const CustomBannerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: size.width,
          height: size.width * 0.425,
          padding: const EdgeInsets.all(20.0), // inner
          decoration: BoxDecoration(
              color: AppColors.kScaffoldColorDark,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                /// Top shadow
                BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(-1, -5), // x, y
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange.withOpacity(0.3)
                        : AppColors.kHabitDark.withOpacity(0.3)),

                /// Bottom shadow
                BoxShadow(
                    blurRadius: 40,
                    offset: const Offset(8, 10),
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange.withOpacity(0.3)
                        : AppColors.kHabitDark.withOpacity(0.3)),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Help articles',
                style: GoogleFonts.lato(
                  fontSize: 24.0,
                  color: AppColors.kTextWhite,
                  fontWeight: TextFontWeight.bold,
                ),
              ),
              16.height,
              Container(
                width: size.width * .425,
                child: Text(
                  'Notes, OCR, Subscription reminder, Account settings',
                  style: GoogleFonts.lato(
                    fontSize: 15.0,
                    color: AppColors.kTextWhite,
                    fontWeight: TextFontWeight.regular,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Positioned(
          bottom: -10,
          right: -30,
          child: Container(
            child: Lottie.asset(AppLottie.helpLottie,
                height: size.width * 0.55, repeat: false),
          ),
        ),
      ],
    );
  }
}

class CustomHelpCategoryCard extends StatefulWidget {
  final String? icon;
  final String? title;

  const CustomHelpCategoryCard({Key? key, this.icon, this.title})
      : super(key: key);

  @override
  State<CustomHelpCategoryCard> createState() => _CustomHelpCategoryCardState();
}

class _CustomHelpCategoryCardState extends State<CustomHelpCategoryCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          width: size.width / 2,
          height: size.width / 2,
          padding: const EdgeInsets.all(20.0), // inner
          decoration: BoxDecoration(
              color: AppColors.kScaffoldColorDark,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                /// Top shadow
                BoxShadow(
                    blurRadius: 3,
                    offset: const Offset(-5, -5),
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange.withOpacity(0.1)
                        : AppColors.kHabitDark.withOpacity(0.1)),

                /// Bottom shadow
                BoxShadow(
                    blurRadius: 3,
                    offset: const Offset(5, 5),
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange.withOpacity(0.1)
                        : AppColors.kHabitDark.withOpacity(0.1)),
              ]),
          child: Center(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.title!,
                style: GoogleFonts.lato(
                  fontSize: 20.0,
                  color: AppColors.kTextWhite,
                  fontWeight: TextFontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // .fill gets a full size (fill the view)
        Positioned.fill(
          bottom: 40,
          // Align to center
          child: Align(
            alignment: Alignment.center,
            child: Container(
              child: Lottie.asset(widget.icon!, height: size.width * 0.4),
            ),
          ),
        ),
      ],
    );
  }
}
