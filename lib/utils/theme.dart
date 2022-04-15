import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'colours.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: createMaterialColor(AppColors.kHabitWhite),
    primaryColor: AppColors.kHabitWhite,
    scaffoldBackgroundColor: AppColors.kHabitBackgroundLightGrey,
    fontFamily: GoogleFonts.lato().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: AppColors.kHabitDark),
    textTheme: TextTheme(headline6: TextStyle(color: AppColors.kHabitDark)),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: viewLineColor,
    cardColor: AppColors.kHabitWhite,
    canvasColor: AppColors.kHabitWhite,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.kHabitDarkGrey),
      backgroundColor: AppColors.kHabitWhite,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
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
    primarySwatch: createMaterialColor(AppColors.kHabitOrange),
    primaryColor: AppColors.kHabitOrange,
    scaffoldBackgroundColor: AppColors.kHabitDarkGrey,
    // fontFamily: GoogleFonts.poppins().fontFamily,
    fontFamily: GoogleFonts.lato().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColors.kHabitDarkGrey),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.kHabitDarkGrey),
    iconTheme: IconThemeData(color: AppColors.kHabitOrange),
    textTheme: TextTheme(headline6: TextStyle(color: AppColors.kHabitDark)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.kHabitDarkGrey),
    dialogBackgroundColor: AppColors.kHabitDarkGrey,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: AppColors.kPrimaryVariantColorDark,
    canvasColor: AppColors.kHabitDarkGrey,
    scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(AppColors.kHabitOrange),
        radius: Radius.circular(8)),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
      backgroundColor: AppColors.kHabitDarkGrey,
      iconTheme: IconThemeData(color: AppColors.kHabitOrange),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
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
