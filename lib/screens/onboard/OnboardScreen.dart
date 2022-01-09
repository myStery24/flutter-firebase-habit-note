import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:habit_note/components/CustomButton.dart';
import 'package:habit_note/components/OnboardDrawerWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';

import '../../main.dart';
import '../auth/LoginScreen.dart';
import '../auth/RegisterScreen.dart';
import 'components/OnboardContent.dart';
import 'components/OnboardTitle.dart';

class OnboardScreen extends StatefulWidget {
  static String tag = '/OnboardScreen';

  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    /// Call it on starting screen only
    SizeConfig().init(context);

    /// Control the back button
    return WillPopScope(
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

      /// Onboard Screen Main Contents
      child: Scaffold(
        backgroundColor: appStore.isDarkMode
            ? AppColors.kHabitBackgroundLightGrey
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
                const SizedBox(height: 30.0),

                /// Arrange the buttons
                ButtonBar(
                  children: <Widget>[
                    /// Create account button
                    CustomButton(
                      text: AppStrings.createAccount,
                      /// Open create account (register) screen
                      onPressed: () {
                        // Navigator.pushNamed(
                        //     context, RegisterScreen.routeName);
                        Navigator.of(context).push(
                          PageTransition(
                            child: RegisterScreen(),
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 600),
                            reverseDuration: const Duration(milliseconds: 600),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30.0),

                    /// Login button
                    CustomButton(
                      text: AppStrings.login,
                      textColor: AppColors.kHabitOrange,
                      color: AppColors.kTextWhite,
                      // Open login screen
                      onPressed: () {
                        Navigator.of(context).push(
                          PageTransition(
                            child: LoginScreen(),
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 600),
                            reverseDuration: const Duration(milliseconds: 600),
                          ),
                        );
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
