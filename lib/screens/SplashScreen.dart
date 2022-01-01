import 'package:flutter/material.dart';
import 'package:mighty_notes/main.dart';
import 'package:mighty_notes/screens/DashboardScreen.dart';
import 'package:mighty_notes/screens/onboard/OnboardScreen.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:mighty_notes/utils/Common.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

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
      appStore.isDarkMode ? AppColors.kHabitDark : AppColors.kHabitOrange,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );
    await Future.delayed(Duration(seconds: 1));
    if (appStore.isLoggedIn.validate()) {
      DashboardScreen().launch(context, isNewTask: true);
    } else {
      OnboardScreen().launch(context, isNewTask: true);
    }
    // if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
    //   WalkThroughScreen().launch(context, isNewTask: true);
    // } else if (appStore.isLoggedIn.validate()) {
    //   DashboardScreen().launch(context, isNewTask: true);
    // } else {
    //   LoginScreen().launch(context, isNewTask: true);
    // }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(
      appStore.isDarkMode ? AppColors.kHabitDark : AppColors.kHabitWhite,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? AppColors.kHabitDark : AppColors.kHabitOrange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          commonCacheImageWidget(
              getBoolAsync(IS_DARK_MODE, defaultValue: false)
                  ? dark_mode_image
                  : light_mode_image,
              150,
              fit: BoxFit.cover),
          Text(AppStrings.appName, style: boldTextStyle(size: 32)),
        ],
      ).center(),
    );
  }
}
