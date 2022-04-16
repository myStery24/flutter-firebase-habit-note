import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationManager() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initNotifications();
  }

  void initNotifications() {
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_logo');
    IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future<void> showScheduleNotification({required DateTime scheduledNotificationDateTime, String? title, String? description, required int id}) async {
    log(scheduledNotificationDateTime);

    await cancelNotification(id);

    var scheduleTime = tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);

    log(scheduleTime);

    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      // 'Channel Description',
      // TODO: Find the logo in mighty notes
      icon: 'app_logo2',
    );
    var iOSDetails = IOSNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      '₹ $description due shortly',
      scheduleTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future onSelectNotification(String? payload) async {
    print('Notification clicked');
    return Future.value(0);
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
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
