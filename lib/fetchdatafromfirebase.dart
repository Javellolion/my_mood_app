import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_mood_app/record_detail.dart'; // เพิ่มการนำเข้าหน้านี้

class Fetchdatafromfirebase extends StatefulWidget {
  const Fetchdatafromfirebase({super.key});

  @override
  State<Fetchdatafromfirebase> createState() => _FetchdatafromfirebaseState();
}

class _FetchdatafromfirebaseState extends State<Fetchdatafromfirebase> {
  final CollectionReference fetchData =
      FirebaseFirestore.instance.collection("daily");

  DateTime now = DateTime.now(); // วันที่ปัจจุบัน
  late DateTime firstDayOfMonth; // วันแรกของเดือนปัจจุบัน
  late DateTime lastDayOfMonth; // วันสุดท้ายของเดือนปัจจุบัน

  @override
  void initState() {
    super.initState();
    // กำหนดวันแรกและวันสุดท้ายของเดือนปัจจุบัน
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // ใช้ .where() เพื่อกรองข้อมูลให้ตรงกับช่วงวันที่ของเดือนปัจจุบัน
        stream: fetchData
            .where('createAt', isGreaterThanOrEqualTo: firstDayOfMonth)
            .where('createAt', isLessThanOrEqualTo: lastDayOfMonth)
            .orderBy('createAt', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    // เมื่อกดที่ภาพ ให้นำไปยังหน้ารายละเอียด
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordDetailPage(
                          pathEmotion: documentSnapshot['pathEmotion'],
                          dailyText: documentSnapshot['dailyText'],
                          levelEmotion: documentSnapshot['levelEmotion'],
                          createdAt: (documentSnapshot['createAt'] as Timestamp)
                              .toDate(),
                          allRecords: streamSnapshot
                              .data!.docs // ส่งบันทึกทั้งหมด
                              .map((doc) => {
                                    'pathEmotion': doc['pathEmotion'],
                                    'dailyText': doc['dailyText'],
                                    'levelEmotion': doc['levelEmotion'],
                                    'createdAt':
                                        (doc['createAt'] as Timestamp).toDate(),
                                  })
                              .toList(),
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    documentSnapshot['pathEmotion'],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
