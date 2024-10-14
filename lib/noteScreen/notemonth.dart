import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MonthlyData extends StatefulWidget {
  const MonthlyData({super.key});

  @override
  State<MonthlyData> createState() => _MonthlyDataState();
}

class _MonthlyDataState extends State<MonthlyData> {
  final CollectionReference dailyData =
      FirebaseFirestore.instance.collection("daily");

  DateTime now = DateTime.now();
  String currentMonth = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$currentMonth',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: dailyData
            .where('createAt',
                isGreaterThanOrEqualTo: DateTime(now.year, now.month, 1))
            .where('createAt',
                isLessThanOrEqualTo: DateTime(now.year, now.month + 1, 0))
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data for this month.'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // Number of images per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              return Image.asset(
                document['pathEmotion'],
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
