import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'screens/SplashScreen.dart';
import 'services/auth_service.dart';
import 'services/notes_service.dart';
import 'services/notification_manager.dart';
import 'services/subscription_service.dart';
import 'services/user_db_service.dart';
import 'store/AppStore.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'utils/string_constant.dart';

AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;

// int adShowCount = 0;

AuthService service = AuthService();
UserDBService userDBService = UserDBService();
NotesService notesService = NotesService();
SubscriptionService subscriptionService = SubscriptionService();
NotificationManager manager = NotificationManager();
UserDBService userService = UserDBService();

Future<void> main() async {
  // TODO: Licensing Fonts: https://pub.dev/packages/google_fonts
  WidgetsFlutterBinding.ensureInitialized();

  defaultRadius = 8.0;
  defaultAppButtonRadius = 30.0;

  await initialize();

  await Firebase.initializeApp().then((value) {
    // .instance.initialize();
  });
  tz.initializeTimeZones();

  if (getBoolAsync(IS_DARK_MODE, defaultValue: false)) {
    appStore.setDarkMode(true);
  } else {
    appStore.setDarkMode(false);
  }

  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  runApp(HaBITNoteApp());
}

class HaBITNoteApp extends StatelessWidget {
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
