// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
//     show DatePicker;
// //import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:my_mood_app/notifi_service.dart';
// import 'package:timezone/data/latest.dart' as tz;

// DateTime scheduleTime = DateTime.now();

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Mood and Feel"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             DatePickerTxt(),
//             ScheduleBtn(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DatePickerTxt extends StatefulWidget {
//   const DatePickerTxt({Key? key}) : super(key: key);

//   @override
//   State<DatePickerTxt> createState() => _DatePickerTxtState();
// }

// class _DatePickerTxtState extends State<DatePickerTxt> {
//   @override
//   void initState() {
//     super.initState();
//     NotificationService().initNotification();
//     tz.initializeTimeZones();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         DatePicker.showDateTimePicker(
//           context,
//           showTitleActions: true,
//           onChanged: (date) {
//             scheduleTime = date; // อัปเดต scheduleTime
//             debugPrint('Changed to: $date');
//           },
//           onConfirm: (date) {
//             setState(() {
//               scheduleTime = date; // อัปเดต scheduleTime
//               debugPrint("Selected Date: $scheduleTime");
//             });
//           },
//         );
//       },
//       child: const Text(
//         "Select Date Time",
//         style: TextStyle(color: Color.fromARGB(255, 238, 7, 215)),
//       ),
//     );
//   }
// }

// class ScheduleBtn extends StatelessWidget {
//   const ScheduleBtn({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       child: const Text("Schedule Notifications"),
//       onPressed: () {
//         if (scheduleTime.isBefore(DateTime.now())) {
//           debugPrint('Cannot schedule notification in the past!');
//           return; // ไม่อนุญาตให้ตั้งการแจ้งเตือนในอดีต
//         }
//         debugPrint('Notification Scheduled for $scheduleTime');
//         NotificationService().scheduleNotification(
//           title: 'Scheduled Notification',
//           body: "Your scheduled time is: $scheduleTime",
//           scheduleNotificationDateTime: scheduleTime,
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Services/notifi_service.dart';
import 'home_page.dart';

void initState() {
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService().initNotification();
  tz.initializeTimeZones();
}

class Notificationpage extends StatelessWidget {
  const Notificationpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notifications',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Local Notifications'),
    );
  }
}
