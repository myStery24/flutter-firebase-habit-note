import 'package:flutter/widgets.dart';
import 'package:mighty_notes/screens/password/ForgotPasswordScreen.dart';
import 'package:mighty_notes/screens/LoginScreen.dart';
import 'package:mighty_notes/screens/RegisterScreen.dart';
import 'package:mighty_notes/screens/onboard/OnboardScreen.dart';

/// Name route for app screen
/// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  // TODO: SET ROUTE NAME
  OnboardScreen.tag: (context) => OnboardScreen(),
  RegisterScreen.tag: (context) => RegisterScreen(),
  LoginScreen.tag: (context) => LoginScreen(),
  ForgotPasswordScreen.tag: (context) => ForgotPasswordScreen(),
  // LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  // CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  // HomeScreen.routeName: (context) => HomeScreen(),
  // NoteEditorScreen.routeName: (context) => NoteEditorScreen();
  // OCRScreen.routeName: (context) => OCRScreen(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
  // SettingsScreen.routeName: (context) => SettingsScreen();
  // AboutScreen.routeName: (context) => AboutScreen();
  // HelpScreen.routeName: (context) => HelpScreen(),
};
