import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:confetti/confetti.dart';
import 'package:habit_note/screens/dashboard/dashboard_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';
import '../../widgets/custom_button.dart';

/// Display when login is successful
class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    ConfettiController(duration: const Duration(seconds: 5));
    _controllerBottomCenter = ConfettiController(duration: const Duration(seconds: 10));
    WidgetsBinding.instance?.addPostFrameCallback((_) => _controllerBottomCenter.play());

    setStatusBarColor(
      AppColors.kHabitOrange,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.dark : Brightness.light,
      delayInMilliSeconds: 100,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.kHabitOrange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter, // shoot from where
            child: ConfettiWidget(
              confettiController: _controllerBottomCenter,
              // set direction
              blastDirection: pi / 2, // down
              minimumSize: const Size(10, 10), // set the minimum potential size for the confetti (width, height)
              maximumSize: const Size(20, 20), // set the maximum potential size for the confetti (width, height)
              // set emission count
              emissionFrequency: 0.3, // a higher number will shot more frequent
              numberOfParticles: 1, // emit how many particle in every shot
              // set intensity
              maxBlastForce: 3, // set a lower max blast force
              minBlastForce: 2,
              // set speed
              gravity: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Awesome !',
              style: TextStyle(
                  color: AppColors.kTextWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 27,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'You have logged in.',
              style: TextStyle(
                  color: AppColors.kTextWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
              ),
            ),
          ),
          SizedBox(
              height: getProportionateScreenHeight(size.height * 0.3),
              width: getProportionateScreenWidth(size.width * 0.8),
              child: SvgPicture.asset(AppImages.success)),
          16.height,
          ButtonBar(
            children: <Widget>[
              /// Back to Dashboard button
              CustomButton(
                color: AppColors.kPrimaryVariantColor,
                textColor: AppColors.kHabitOrange,
                text: AppStrings.back,
                onPressed: () {
                  DashboardScreen().launch(context, isNewTask: true);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
