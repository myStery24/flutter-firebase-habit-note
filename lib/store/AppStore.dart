import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  Color primaryColor = Colors.blue;

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

      defaultLoaderBgColorGlobal = AppColors.scaffoldSecondaryDark;
      // appButtonBackgroundColorGlobal = appButtonColorDark;
      appButtonBackgroundColorGlobal = AppColors.kHabitOrange;
      shadowColorGlobal = Colors.white12;

      setStatusBarColor(AppColors.kHabitDark, statusBarIconBrightness: Brightness.light);
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
