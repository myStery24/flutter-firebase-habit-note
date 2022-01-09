import 'package:flutter/widgets.dart';
import 'package:habit_note/screens/SplashScreen.dart';
import 'package:habit_note/screens/notes/NotesScreen.dart';
import 'package:habit_note/screens/password/ChangeAppPasswordScreen.dart';
import 'package:habit_note/screens/password/ForgotPasswordScreen.dart';
import 'package:habit_note/screens/auth/LoginScreen.dart';
import 'package:habit_note/screens/auth/RegisterScreen.dart';
import 'package:habit_note/screens/onboard/OnboardScreen.dart';
import 'package:habit_note/screens/password/NotesPasswordProtectionScreen.dart';

/// Name route for app screen
/// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  // TODO: SET ROUTE NAME
  SplashScreen.tag: (context) => SplashScreen(),
  OnboardScreen.tag: (context) => OnboardScreen(),
  RegisterScreen.tag: (context) => RegisterScreen(),
  LoginScreen.tag: (context) => LoginScreen(),
  ForgotPasswordScreen.tag: (context) => ForgotPasswordScreen(),
  ChangeAppPasswordScreen.tag: (context) => ChangeAppPasswordScreen(),
  ChangeMasterPasswordScreen.tag: (context) => ChangeMasterPasswordScreen(),
  NotesScreen.tag: (context) => NotesScreen(),
  // CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  // HomeScreen.routeName: (context) => HomeScreen(),
  // NoteEditorScreen.routeName: (context) => NoteEditorScreen();
  // OCRScreen.routeName: (context) => OCRScreen(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
  // SettingsScreen.routeName: (context) => SettingsScreen();
  // AboutScreen.routeName: (context) => AboutScreen();
  // HelpScreen.routeName: (context) => HelpScreen(),
};
