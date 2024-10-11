import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  DateTime? selectedDateTime;
  bool isDaily = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      //iOS: IOSInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    if (selectedDateTime == null) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Mood&Feel',
      'Time to Note!',
      tz.TZDateTime.from(selectedDateTime!, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel_id',
          'Daily Notifications',
          channelDescription: 'notification for note',
          importance: Importance.high,
        ),
        //iOS: IOSNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: isDaily ? DateTimeComponents.time : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('set notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: const Text('set date and time'),
            ),
            Text(
              selectedDateTime != null
                  ? 'Day: ${DateFormat.yMMMd().format(selectedDateTime!)} เวลา: ${DateFormat.Hm().format(selectedDateTime!)}'
                  : 'no have day and time to select',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isDaily,
                  onChanged: (bool? value) {
                    setState(() {
                      isDaily = value ?? false;
                    });
                  },
                ),
                const Text('Every Day'),
              ],
            ),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: const Text('Set Time'),
            ),
          ],
        ),
      ),
    );
  }
}
