import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  Color primaryColor = Color(0xFFFFB347);

  @observable
  bool isLoggedIn = false;

  @observable
  bool isLoading = false;

  @observable
  bool isDarkMode = false;

  @action
  void setPrimaryColor(Color color) => primaryColor = color;

  @action
  void setLoading(bool val) => isLoading = val;

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
  }

  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = AppColors.kScaffoldSecondaryDark;
      appButtonBackgroundColorGlobal = AppColors.kHabitOrange;
      shadowColorGlobal = Colors.white12;

      setStatusBarColor(AppColors.kPrimaryVariantColorDark, statusBarIconBrightness: Brightness.light);
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;

      setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);
    }
  }
}
