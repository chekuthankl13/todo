import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification(
      {required int year,
      required int month,
      required int day,
      required int hour,
      required int minutes,
      required String title}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidDetails = const AndroidNotificationDetails(
        "Todo"
            "high_importance_channel",
        "High Importance Channel",
        // sound: RawResourceAndroidNotificationSound("sound"),
        colorized: true,
        priority: Priority.high,
        importance: Importance.max);
    var iSODetails = const DarwinNotificationDetails(
        presentAlert: true, // Required to display a heads up notification
        presentBadge: true,
        presentSound: true,
        sound: "sound");
    var platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iSODetails,
    );

    tz.initializeTimeZones();
    String timeZoneName = 'Asia/Kolkata';
    tz.Location timeZone = tz.getLocation(timeZoneName);

    var scheduledDate = tz.TZDateTime(
      timeZone,
      year,
      month,
      day,
      hour,
      minutes,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      title,
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '',
    );

    log("notification scheduled for $scheduledDate");
  }
}
