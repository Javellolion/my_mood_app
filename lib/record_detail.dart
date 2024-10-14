import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordDetailPage extends StatefulWidget {
  final String pathEmotion;
  final String dailyText;
  final String levelEmotion;
  final DateTime createdAt;
  final List<Map<String, dynamic>> allRecords;

  const RecordDetailPage({
    super.key,
    required this.pathEmotion,
    required this.dailyText,
    required this.levelEmotion,
    required this.createdAt,
    required this.allRecords,
  });

  @override
  _RecordDetailPageState createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  late List<Map<String, dynamic>> records;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    records = List.from(widget.allRecords);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedContent();
    });
  }

  void _scrollToSelectedContent() {
    final selectedIndex = records.indexWhere((record) =>
        record['pathEmotion'] == widget.pathEmotion &&
        record['dailyText'] == widget.dailyText &&
        record['levelEmotion'] == widget.levelEmotion &&
        record['createdAt'] == widget.createdAt);
    if (selectedIndex != -1) {
      _scrollController.animateTo(
        selectedIndex * 150.0, // ปรับขนาดตามความสูงของรายการ
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Image.asset(record['pathEmotion'],
                          width: 100, height: 100),
                      const SizedBox(height: 10),
                      Text(record['dailyText'],
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                      Text(
                        DateFormat('dd MMMM yyyy').format(record['createdAt']),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
