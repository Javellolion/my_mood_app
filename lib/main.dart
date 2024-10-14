import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_mood_app/add_emo.dart';
import 'package:my_mood_app/overall_emo.dart';
import 'package:my_mood_app/notificationpage.dart';
import 'package:my_mood_app/profile.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core package
import 'package:my_mood_app/FetchDataFromFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // import cloud_firestore

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return MaterialApp(
      //title: "Hello Flutter",
      home: Scaffold(
        drawer: Builder(
          builder: (BuildContext newContext) {
            return Drawer(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text("Home"),
                    onTap: () {
                      Navigator.of(newContext).push(
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Emo Note"),
                    onTap: () {
                      Navigator.of(newContext).push(
                        MaterialPageRoute(
                          builder: (context) => const OverallEmo(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Edit Notification"),
                    onTap: () {
                      Navigator.of(newContext).push(
                        MaterialPageRoute(
                          builder: (context) => const Notificationpage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Profile"),
                    onTap: () {
                      Navigator.of(newContext).push(
                        MaterialPageRoute(
                          builder: (context) => const Profile(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        appBar: AppBar(
          title: Text(
            DateFormat('   yyyy\nMMMM').format(now),
            style: const TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Fetchdatafromfirebase(), // แทรก Fetchdatafromfirebase
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Builder(
                  builder: (BuildContext buttonContext) {
                    return FutureBuilder<bool>(
                      future: _checkIfEmotionAddedToday(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // แสดงโลดริ้งระหว่างตรวจสอบ
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.data!) {
                          // หากไม่มีการบันทึกในวันนี้ ให้แสดงปุ่ม
                          return FilledButton(
                            onPressed: () {
                              Navigator.push(
                                buttonContext,
                                MaterialPageRoute(
                                    builder: (context) => const AddEmo()),
                              );
                            },
                            child: const Icon(Icons.add),
                          );
                        }
                        return const SizedBox
                            .shrink(); // หากมีการบันทึกแล้ว ไม่แสดงปุ่ม
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkIfEmotionAddedToday() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final querySnapshot = await FirebaseFirestore.instance
        .collection("daily")
        .where('createAt', isGreaterThanOrEqualTo: startOfDay)
        .where('createAt', isLessThanOrEqualTo: endOfDay)
        .get();

    return querySnapshot.docs.isNotEmpty; // คืนค่า true หากมีการบันทึกในวันนี้
  }
}
