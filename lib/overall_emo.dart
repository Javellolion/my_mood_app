import 'package:flutter/material.dart';
import 'package:my_mood_app/noteScreen/noteweek.dart';
import 'package:my_mood_app/noteScreen/notemonth.dart';
import 'package:my_mood_app/noteScreen/noteyear.dart';

class OverallEmo extends StatefulWidget {
  const OverallEmo({super.key});

  @override
  State<OverallEmo> createState() => _OverallEmo();
}

class _OverallEmo extends State<OverallEmo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Emo Note'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Text("Week"),
                ),
                Tab(
                  icon: Text("Month"),
                ),
                Tab(
                  icon: Text("Year"),
                ),
              ],
            ), // ชื่อของหน้าที่จะแสดงใน AppBar
          ),
          body: TabBarView(
            children: [
              Center(child: WeeklyData()),
              Center(child: MonthlyData()),
              Center(child: YearlyData()),
            ],
          ),
        ));
  }
}
