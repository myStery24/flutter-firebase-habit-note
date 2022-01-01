import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mighty_notes/components/CustomButton.dart';
import 'package:mighty_notes/components/OnboardDrawerWidget.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:page_transition/page_transition.dart';

import '../../main.dart';
import '../LoginScreen.dart';
import '../RegisterScreen.dart';
import 'components/OnboardContent.dart';
import 'components/OnboardTitle.dart';

class OnboardScreen extends StatefulWidget {
  static String tag = '/OnboardScreen';

  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    /// Call it on starting screen only
    SizeConfig().init(context);
    return Scaffold(
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
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
                  // Open create account (register) screen
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

                /// Log in button
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
    );
  }
}
