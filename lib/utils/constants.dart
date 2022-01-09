import 'package:flutter/material.dart';
import 'colors.dart';

const imageRadius = 40.0;

const mAdMobAppId = 'ca-app-pub-1399327544318575~9252792385';
const mAdMobBannerId = 'ca-app-pub-1399327544318575/4738832302';
const mAdMobInterstitialId = 'ca-app-pub-1399327544318575/8573796227';

List<String> testDevices = ['551597FF6B95q52FEBB440722967BCB6F'];

// Login Type
const LoginTypeApp = 'app';
const LoginTypeGoogle = 'google';
const LoginTypeApple = 'apple';

const GRID_VIEW = 'GRID_VIEW';
const GRID_VIEW_2 = 'GRID_VIEW_2';
const LIST_VIEW = 'LIST_VIEW';

const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_FIRST_TIME = 'IS_FIRST_TIME';
const NOTE_ID = 'NOTE_ID';
const USER_ID = 'USER_ID';
const USERNAME = 'USERNAME';
const PASSWORD = 'PASSWORD';
const USER_EMAIL = 'USER_EMAIL';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const USER_PHOTO_URL = 'USER_PHOTO_URL';
const USER_MASTER_PWD = 'USER_MASTER_PWD';
const IS_DARK_MODE = 'IS_DARK_MODE';
const LOGIN_TYPE = 'LOGIN_TYPE';

// enable disable Ads
// default is false = will have ads
const disabled_ads = true;

const FIT_COUNT = 'FIT_COUNT';
const CROSS_COUNT = 'CROSS_COUNT';
const SELECTED_LAYOUT_TYPE_DASHBOARD = 'SELECTED_LAYOUT_TYPE_DASHBOARD';

const dark_mode_image = 'assets/images/logo_night_mode.png';
const light_mode_image = 'assets/images/logo_light_mode.png';

/// HaBIT Note
const kAnimationDuration = Duration(milliseconds: 200);

class TextFontWeight {
  static const thin = FontWeight.w100;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const bold = FontWeight.w700;
  static const black = FontWeight.w900;
}

class AppImages {
  // Images route (directory)
  static const String imageDir = 'assets/images';

  // Images
  static const empty = '$imageDir/empty.png';
  static const logo = '$imageDir/logo.png';
  static const user = '$imageDir/user.png';
  static const placeholder = '$imageDir/placeholder.png';

  static const onboard = '$imageDir/onboard.png';
  static const onboard1 = '$imageDir/onboard1.png';
  static const onboard2 = '$imageDir/onboard2.png';
}

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: AppColors.kHintTextLightGrey),
  );
}
