import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:habit_note/components/custom_button.dart';
import 'package:habit_note/components/onboard_drawer_widget.dart';
import 'package:habit_note/utils/routes.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'components/onboard_content.dart';
import 'components/onboard_title.dart';

class OnboardScreen extends StatefulWidget {
  static String tag = '/OnboardScreen';

  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? AppColors.kHabitDarkGrey : AppColors.kHabitBackgroundLightGrey,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );

    setState(() {});
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
    /// Call it on starting screen only
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;

    /// Control the back button
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > 2.seconds) {
          currentBackPressTime = now;
          toast(AppStrings.pressAgain);
          return Future.value(false);
        }
        return Future.value(true);
      },

      /// Onboard Screen Main Contents
      child: Scaffold(
        backgroundColor: appStore.isDarkMode
            ? AppColors.kHabitDarkGrey
            : AppColors.kHabitBackgroundLightGrey,

        /// A sidebar navigation drawer widget
        drawer: const OnboardDrawerWidget(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.kHabitOrange),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// A welcome title text with app name
                const OnboardTitle(),

                /// A scrollable widget with image, header and body text
                OnboardContent(),

                /// Arrange the buttons
                ButtonBar(
                  children: <Widget>[
                    /// Create account button
                    CustomButton(
                      text: AppStrings.createAccount,
                      /// Open create account (register) screen
                      onPressed: () {
                        Navigator.push(context, AppRoutes().createAccountScreen);
                      },
                    ),
                     // const SizedBox(height: 30.0),
                    Container(
                      height: size.height * 0.035,
                    ),

                    /// Login button
                    CustomButton(
                      text: AppStrings.login,
                      textColor: AppColors.kHabitOrange,
                      color: AppColors.kTextWhite,
                      /// Open login screen
                      onPressed: () {
                        Navigator.push(context, AppRoutes().loginScreen);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
