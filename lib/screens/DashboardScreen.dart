import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:habit_note/components/DashboardDrawerWidget.dart';
import 'package:habit_note/screens/ocr/TextRecognitionScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import 'HelpScreen.dart';
import 'SettingsScreen.dart';
import 'notes/NotesScreen.dart';
import 'ocr/OCRScreen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/string_constant.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  int index = 0;
  int activeTab = 0;

  String colorFilter = '';

  String? name;
  String? userEmail;
  String? imageUrl;

  DateTime? currentBackPressTime;

  late int crossAxisCount;
  late int fitWithCount;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    fitWithCount = getIntAsync(FIT_COUNT, defaultValue: 1);
    crossAxisCount = getIntAsync(CROSS_COUNT, defaultValue: 2);
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
        // TODO: OCR
        return OCRScreen();
        // return TextRecognitionScreen();
      case 2:
        // TODO: HELP
        return HelpScreen();
      case 3:
        // TODO: SETTINGS/ME
        return SettingsScreen();
      case 0:
      default:
        return NotesScreen();
    }
  }

  Widget buildBottomNavBar() {
    final inactiveColor = Colors.grey;
    return BottomNavyBar(
      backgroundColor: AppColors.kPrimaryVariantColorDark,
      containerHeight: 70.0,
      itemCornerRadius: 12,
      selectedIndex: index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.sticky_note_2_sharp),
          title: Text('Notes'),
          textAlign: TextAlign.center,
          activeColor: AppColors.kHabitOrange,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.image_search_outlined),
          title: Text('OCR'),
          textAlign: TextAlign.center,
          activeColor: AppColors.kHabitOrange,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.help_outline),
          title: Text('Help'),
          textAlign: TextAlign.center,
          activeColor: AppColors.kHabitOrange,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.person_outline),
          title: Text('Me'),
          textAlign: TextAlign.center,
          activeColor: AppColors.kHabitOrange,
          inactiveColor: inactiveColor,
        ),
      ],
      onItemSelected: (index) => setState(() => this.index = index),
    );
  }
}
