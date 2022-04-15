import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'dashboard_screen.dart';
import 'onboard/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      AppColors.kHabitOrange,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );
    await Future.delayed(Duration(seconds: 1));
    if (appStore.isLoggedIn.validate()) {
      DashboardScreen().launch(context, isNewTask: true);
    } else {
      OnboardScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kHabitOrange,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.only(top: 120.0),
              child: commonCacheImageWidget(
                  getBoolAsync(IS_DARK_MODE)
                      ? AppImages.logoNight
                      : AppImages.logoLight,
                  150,
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.appName,
                style: GoogleFonts.fugazOne(
                  fontSize: 32.0,
                  color: AppColors.kTextBlack,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250.0),
              child: Text(
                AppStrings.appCopyright,
                style: GoogleFonts.lato(
                  fontSize: 14.0,
                  color: AppColors.kTextBlack,
                ),
              ),
            ),
          ],
        ).center(),
      ),
    );
  }
}
