import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  /// Initialize the plugin instance
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationManager() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initNotifications();
  }

  /// Function for calling the notification
  void initNotifications() {
    // Android
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // [projectFolder]/android/app/src/main/res/drawable
    // iOS
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // Initialize Android and iOS settings
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> showScheduleNotification(
      {required DateTime scheduledNotificationDateTime,
      String? title,
      String? description,
      required int id}) async {
    log(scheduledNotificationDateTime);

    await cancelNotification(id);

    // the time to call out the notification
    var scheduleTime =
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);

    log(scheduleTime);

    var androidDetails = AndroidNotificationDetails(
      'id',
      // change this id # if you change any settings else reinstall the app
      'name',
      // 'description',
      priority: Priority.high,
      importance: Importance.max, // show in banner
      icon: '@mipmap/ic_launcher',
    );
    var iOSDetails = IOSNotificationDetails();
    var platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // show the notification details
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      'RM $description due shortly',
      scheduleTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'Default_Sound',
    );
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      print('Notification payload: $payload');
    } else {
      print('Notification clicked');
    }
    return Future.value(0);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details
    return Future.value(1);
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
