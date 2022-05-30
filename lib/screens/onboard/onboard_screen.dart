import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../configs/routes.dart';
import '../../main.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/onboard_drawer_widget.dart';
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
      appStore.isDarkMode ? AppColors.kPrimaryVariantColorDark : AppColors.kPrimaryVariantColor,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.dark : Brightness.light,
      delayInMilliSeconds: 100,
    );

    /// When loading the onboard screen, set the orientation portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    /// When leaving the onboard screen,set back to normal (applies to all screens after login)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Call it on starting screen only
    SizeConfig().init(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appStore.isDarkMode
              ? AppColors.kScaffoldColorDark
              : AppColors.kScaffoldColor,

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
              child: Container(
                width: screenWidth,
                height: screenHeight,
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
                        18.height,

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
                        16.height,
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
