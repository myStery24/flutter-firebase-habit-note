import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:habit_note/screens/ocr/ocr_screen.dart';
import 'package:habit_note/screens/settings/me_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../widgets/dashboard_drawer_widget.dart';
import '../help/help_screen.dart';
import '../notes/notes_screen.dart';

/// The home screen after login
class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  int index = 0;
  int activeTab = 0;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
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
      child: WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) > 2.seconds) {
            currentBackPressTime = now;
            toast(AppStrings.pressAgain);
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          key: _scaffoldState,
          drawer: DashboardDrawerWidget(),
          body: buildBody(),

            /// Custom Bottom Navigation Bar
            bottomNavigationBar: buildBottomNavBar(),
          ),
        ),
      );
  }

  Widget buildBody() {
    switch (index) {
      case 1:
        /// OCR
        return OCRScreen();
      case 2:
        /// FAQ
        // TODO: HELP
        return HelpScreen();
      case 3:
        /// Settings
        return MeScreen();
      case 0:
      default:
        /// Home
        return NotesScreen();
    }
  }

  /// Custom navigation bar
  Widget buildBottomNavBar() {
    final inactiveColor =  AppColors.kPrimaryVariantColorDark;
    final activeColor = Colors.white;

    return BottomNavyBar(
      backgroundColor: AppColors.kHabitOrange,
      containerHeight: 70.0,
      itemCornerRadius: 12,
      selectedIndex: index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.sticky_note_2_sharp),
          title: Text('Notes'),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.image_search_outlined),
          title: Text('OCR'),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.help_outline),
          title: Text('Help'),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.person_outline),
          title: Text('Me'),
          textAlign: TextAlign.center,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ],
      onItemSelected: (index) => setState(() => this.index = index),
    );
  }
}
