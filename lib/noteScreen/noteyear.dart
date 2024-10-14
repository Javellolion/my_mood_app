import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class YearlyData extends StatefulWidget {
  const YearlyData({super.key});

  @override
  State<YearlyData> createState() => _YearlyDataState();
}

class _YearlyDataState extends State<YearlyData> {
  final CollectionReference dailyData =
      FirebaseFirestore.instance.collection("daily");

  DateTime now = DateTime.now();
  String currentYear = DateFormat('yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$currentYear'), centerTitle: true),
      body: StreamBuilder(
        stream: dailyData
            .where('createAt', isGreaterThanOrEqualTo: DateTime(now.year, 1, 1))
            .where('createAt',
                isLessThanOrEqualTo: DateTime(now.year + 1, 1, 0))
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data for this year.'));
          }

          // Create a map to organize data by month
          Map<int, List<DocumentSnapshot>> dataByMonth = {};
          for (var document in snapshot.data!.docs) {
            DateTime createAt = (document['createAt'] as Timestamp).toDate();
            int month = createAt.month;
            if (!dataByMonth.containsKey(month)) {
              dataByMonth[month] = [];
            }
            dataByMonth[month]!.add(document);
          }

          return ListView.builder(
            itemCount: dataByMonth.keys.length,
            itemBuilder: (context, index) {
              int month = dataByMonth.keys.elementAt(index);
              List<DocumentSnapshot> monthData = dataByMonth[month]!;

              String monthName =
                  DateFormat('MMMM').format(DateTime(now.year, month));

              return Column(
                children: [
                  Text(
                    monthName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GridView.builder(
                    shrinkWrap: true, // ย่อขนาด GridView ให้เหมาะสม

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // จำนวนภาพในแถวเดียว
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio:
                          1, // กำหนดสัดส่วนช่องให้เป็นสี่เหลี่ยมจัตุรัส
                    ),
                    itemCount: monthData.length,
                    itemBuilder: (context, index) {
                      final document = monthData[index];
                      return Container(
                        padding: const EdgeInsets.all(
                            8.0), // เพิ่ม padding เพื่อให้ภาพห่างจากขอบ
                        child: Image.asset(
                          document['pathEmotion'],
                          fit:
                              BoxFit.contain, // หรือใช้ BoxFit.cover ตามต้องการ
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
