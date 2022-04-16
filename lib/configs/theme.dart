import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // basic config for light theme
    primaryColor: AppColors.kPrimaryVariantColor, // app bar
    primarySwatch: createMaterialColor(AppColors.kPrimaryVariantColor), // buttons
    scaffoldBackgroundColor: AppColors.kPrimaryVariantColor,
    fontFamily: GoogleFonts.lato().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: AppColors.kHabitDark),
    textTheme: TextTheme(headline6: TextStyle(color: AppColors.kTextBlack)),
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.kHabitDark),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: viewLineColor,
    cardColor: Colors.white,
    canvasColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.kHabitOrange),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.kPrimaryVariantColorDark),
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(AppColors.kHabitDark),
        radius: Radius.circular(8)),
    dialogTheme: DialogTheme(shape: dialogShape()),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.kPrimaryVariantColorDark,
    primarySwatch: createMaterialColor(AppColors.kPrimaryVariantColorDark),
    scaffoldBackgroundColor: AppColors.kPrimaryVariantColorDark,
    fontFamily: GoogleFonts.lato().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColors.kHabitDark),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.kPrimaryVariantColorDark),
    iconTheme: IconThemeData(color: AppColors.kHabitOrange),
    textTheme: TextTheme(headline6: TextStyle(color: AppColors.kTextWhite)),
    dialogBackgroundColor: AppColors.kPrimaryVariantColorDark,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: AppColors.kPrimaryVariantColorDark,
    canvasColor: AppColors.kPrimaryVariantColorDark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.kHabitOrange),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
      backgroundColor: AppColors.kPrimaryVariantColorDark,
      iconTheme: IconThemeData(color: AppColors.kHabitOrange),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(AppColors.kHabitOrange),
        radius: Radius.circular(8)),
    dialogTheme: DialogTheme(shape: dialogShape()),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
