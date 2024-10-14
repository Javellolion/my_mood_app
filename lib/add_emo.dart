import 'package:flutter/material.dart';
import 'package:my_mood_app/main.dart';
//import 'package:intl/intl.dart';
import 'package:my_mood_app/store_data.dart'; // นำเข้า StoreData
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddEmo extends StatefulWidget {
  const AddEmo({super.key});

  @override
  State<AddEmo> createState() => _AddEmoState();
}

class _AddEmoState extends State<AddEmo> {
  String? selectedEmotion; // เก็บชื่อของอารมณ์ที่ผู้ใช้เลือก
  bool showForm = false; // ใช้ตรวจสอบว่าจะแสดงฟอร์มหรือไม่
  double value = 0; // เก็บระดับความรู้สึก
  final formKey = GlobalKey<FormState>();
  StoreData info = StoreData(); // อินสแตนซ์ของคลาส StoreData เพื่อเก็บข้อมูล
  CollectionReference storeData =
      FirebaseFirestore.instance.collection("daily");

  final Map<String, String> emotions = {
    'Accepting': 'assets/images/Accepting.png',
    'Angry': 'assets/images/Angry.png',
    'Annoyed': 'assets/images/Annoyed.png',
    'Cool': 'assets/images/Cool.png',
    'Crying Hard': 'assets/images/CryingHard.png',
    'Dislike': 'assets/images/Dislike.png',
    'Embarrassed': 'assets/images/Embarrassed.png',
    'Frustrated': 'assets/images/Frustrated.png',
    'Fun': 'assets/images/Fun.png',
    'Happy': 'assets/images/Happy.png',
    'InLove': 'assets/images/InLove.png',
    'Nervous': 'assets/images/Nervous.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Emotion"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select an Emotion", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              // ใช้ ListWheelScrollView เพื่อเลื่อนแบบวงล้อ
              SizedBox(
                height: 200,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 80,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedEmotion = emotions.keys.elementAt(index);
                      info.pathEmotion = emotions[selectedEmotion]!;
                      showForm = true;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final emotion = emotions.keys.elementAt(index);
                      bool isSelected = selectedEmotion == emotion;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmotion = emotion;
                            info.pathEmotion = emotions[emotion]!;
                            showForm = true;
                          });
                        },
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                emotions[emotion]!,
                                width: isSelected ? 80 : 60,
                                height: isSelected ? 70 : 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    childCount: emotions.length,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedOpacity(
                opacity: showForm ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: showForm ? _buildForm() : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        Text(
          "$selectedEmotion",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Type your daily",
              border: OutlineInputBorder(),
            ),
            onSaved: (String? value) {
              info.dailyText = value ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter something";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text("How much level your feeling."),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Slider(
            value: value,
            max: 10,
            divisions: 10,
            label: value.round().toString(),
            onChanged: (double currentValue) {
              setState(() {
                value = currentValue;
              });
            },
            onChangeEnd: (double currentValue) {
              info.levelEmotion = currentValue.toString();
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            formKey.currentState!.save();

            // ตรวจสอบว่ามีการบันทึกในวันเดียวกันแล้วหรือไม่
            final today = DateTime.now();
            final startOfDay = DateTime(today.year, today.month, today.day);
            final endOfDay =
                DateTime(today.year, today.month, today.day, 23, 59, 59);

            final querySnapshot = await storeData
                .where('createAt', isGreaterThanOrEqualTo: startOfDay)
                .where('createAt', isLessThanOrEqualTo: endOfDay)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              // หากมีการบันทึกแล้ว แสดงข้อความแจ้งเตือน
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("You can only add your emotion once a day!")),
              );
              return;
            }

            // ถ้ายังไม่เคยบันทึก ให้บันทึกข้อมูล
            await storeData.add({
              "pathEmotion": info.pathEmotion,
              "dailyText": info.dailyText,
              "levelEmotion": info.levelEmotion,
              "createAt": FieldValue.serverTimestamp(),
            });

            formKey.currentState!.reset();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitCircle(
                        color: Colors.green,
                        size: 50.0,
                      ),
                      const SizedBox(height: 20),
                      const Text("Data has been saved!"),
                    ],
                  ),
                );
              },
            );
            await Future.delayed(const Duration(seconds: 2));
            Navigator.of(context).pop(); // ปิด dialog
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
