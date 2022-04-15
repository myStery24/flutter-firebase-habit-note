import 'package:flutter/widgets.dart';
import 'package:habit_note/components/privacy_policy_screen.dart';
import 'package:habit_note/screens/auth/login_screen.dart';
import 'package:habit_note/screens/auth/register_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../components/terms_of_use_screen.dart';

/// Name route for app screen
/// All our routes will be available here

class AppRoutes {
  PageTransition createAccountScreen = PageTransition(
    child: RegisterScreen(),
    type: PageTransitionType.rightToLeftWithFade,
    duration: const Duration(milliseconds: 600),
    reverseDuration: const Duration(milliseconds: 600),
  );

  PageTransition loginScreen = PageTransition(
    child: LoginScreen(),
    type: PageTransitionType.rightToLeftWithFade,
    duration: const Duration(milliseconds: 600),
    reverseDuration: const Duration(milliseconds: 600),
  );

  PageTransition termsScreen = PageTransition(
    child: TermsOfUseScreen(),
    type: PageTransitionType.rightToLeftWithFade,
    alignment: Alignment.center,
    curve: Curves.easeInOutBack,
    duration: Duration(milliseconds: 500),
  );

  PageTransition privacyScreen = PageTransition(
    child: PrivacyPolicyScreen(),
    type: PageTransitionType.rightToLeftWithFade,
    alignment: Alignment.center,
    curve: Curves.easeInOutBack,
    duration: Duration(milliseconds: 500),
  );
}