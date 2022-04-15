import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/notes_service.dart';
import 'services/notification_manager.dart';
import 'services/subscription_service.dart';
import 'services/user_db_service.dart';
import 'store/app_store.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';

/// Initialize services
AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;

AuthService service = AuthService();
UserDBService userDBService = UserDBService();
NotesService notesService = NotesService();
SubscriptionService subscriptionService = SubscriptionService();
NotificationManager manager = NotificationManager();
UserDBService userService = UserDBService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultRadius = 8.0;
  defaultAppButtonRadius = 30.0;

  await initialize();

  /// Initialize Firebase
  await Firebase.initializeApp().then((value) {
  });
  tz.initializeTimeZones();

  /// Set state for app theme
  if (getBoolAsync(IS_DARK_MODE, defaultValue: false)) {
    appStore.setDarkMode(true);
  } else {
    appStore.setDarkMode(false);
  }

  /// Get the user login state
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN)); // either true or false

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
