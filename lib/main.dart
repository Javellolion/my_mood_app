import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_mood_app/add_emo.dart';
import 'package:my_mood_app/overall_emo.dart';
import 'package:my_mood_app/notificationpage.dart';
import 'package:my_mood_app/profile.dart';

void main() {
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
                          builder: (context) => const NotificationPage(),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Builder(
                  builder: (BuildContext buttonContext) {
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
