import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mighty_notes/screens/SplashScreen.dart';
import 'package:mighty_notes/services/AuthService.dart';
import 'package:mighty_notes/services/NotesServices.dart';
import 'package:mighty_notes/services/NotificationManager.dart';
import 'package:mighty_notes/services/SubscriptionService.dart';
import 'package:mighty_notes/services/UserDBService.dart';
import 'package:mighty_notes/store/AppStore.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'AppTheme.dart';

HaBITNoteApp appStore = HaBITNoteApp();

FirebaseFirestore db = FirebaseFirestore.instance;

int adShowCount = 0;

AuthService service = AuthService();
UserDBService userDBService = UserDBService();
NotesServices notesService = NotesServices();
SubscriptionService subscriptionService = SubscriptionService();
NotificationManager manager = NotificationManager();
UserDBService userService = UserDBService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultRadius = 8.0;
  defaultAppButtonRadius = 30.0;

  await initialize();

  await Firebase.initializeApp().then((value) {
    MobileAds.instance.initialize();
  });
  tz.initializeTimeZones();

  if (getBoolAsync(IS_DARK_MODE, defaultValue: false)) {
    appStore.setDarkMode(true);
  } else {
    appStore.setDarkMode(false);
  }

  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
        builder: scrollBehaviour(),
      ),
    );
  }
}
