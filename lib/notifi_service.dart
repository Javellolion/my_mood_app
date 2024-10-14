// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:permission_handler/permission_handler.dart'; // นำเข้า permission_handler

// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('flutter_logo');

//     var initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {},
//     );

//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }

//   Future<NotificationDetails> notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   Future<void> requestExactAlarmPermission() async {
//     var status = await Permission.ignoreBatteryOptimizations
//         .status; // อนุญาตให้แอปละเลยการปรับแต่งแบตเตอรี่
//     if (!status.isGranted) {
//       await Permission.ignoreBatteryOptimizations.request();
//     }
//   }

//   Future<void> scheduleNotification({
//     required DateTime scheduleNotificationDateTime,
//     String? title,
//     String? body,
//   }) async {
//     await requestExactAlarmPermission(); // ขออนุญาตก่อนตั้งการแจ้งเตือน

//     if (scheduleNotificationDateTime.isBefore(DateTime.now())) {
//       debugPrint('Schedule time is in the past. Please select a future time.');
//       return;
//     }

//     debugPrint(
//         'Scheduling notification with title: $title, body: $body, time: $scheduleNotificationDateTime');

//     await notificationsPlugin.zonedSchedule(
//       0,
//       title,
//       body,
//       tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
//       await notificationDetails(),
//       androidScheduleMode:
//           AndroidScheduleMode.inexact, // ใช้การตั้งเวลาแบบไม่แม่นยำ
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }
