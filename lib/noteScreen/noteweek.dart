import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WeeklyData extends StatefulWidget {
  const WeeklyData({super.key});

  @override
  State<WeeklyData> createState() => _WeeklyDataState();
}

class _WeeklyDataState extends State<WeeklyData> {
  final CollectionReference dailyData =
      FirebaseFirestore.instance.collection("daily");

  DateTime now = DateTime.now();

// Get the start and end of the current week
  DateTime get startOfWeek {
    return now.subtract(Duration(days: now.weekday)); // Monday
  }

  DateTime get endOfWeek {
    return startOfWeek
        .add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59)); // Sunday
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly (${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d').format(endOfWeek)})',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: dailyData
            .where('createAt', isGreaterThanOrEqualTo: startOfWeek)
            .where('createAt', isLessThanOrEqualTo: endOfWeek)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data for this week.'));
          }

          List<DocumentSnapshot> weekData = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: weekData.length,
            itemBuilder: (context, index) {
              final document = weekData[index];
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  document['pathEmotion'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                        Icons.error); // แสดงไอคอนเมื่อเกิดข้อผิดพลาด
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
