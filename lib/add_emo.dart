import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_mood_app/store_data.dart'; // นำเข้า StoreData

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
  //เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // รายการของอารมณ์ต่างๆ พร้อมกับพาร์ทของไฟล์รูปภาพ
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
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Error"),
                ),
                body: Center(child: Text("${snapshot.error}")));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                body: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Select an Emotion",
                        style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 20),
                    // ใช้ ListWheelScrollView เพื่อเลื่อนแบบวงล้อ
                    SizedBox(
                      height: 200, // ขนาดของวงล้อ
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 80, // ขนาดของแต่ละรายการ
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedEmotion =
                                emotions.keys.elementAt(index); // เลือกอารมณ์
                            info.pathEmotion = emotions[
                                selectedEmotion]!; // เก็บพาร์ทของไฟล์รูปภาพ
                            showForm = true; // แสดงฟอร์มเมื่อเลือกอารมณ์แล้ว
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
                                  info.pathEmotion = emotions[
                                      emotion]!; // เก็บพาร์ทของไฟล์รูปภาพใน StoreData
                                  showForm = true;
                                });
                              },
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      emotions[emotion]!,
                                      width: isSelected
                                          ? 80
                                          : 60, // ขนาดรูปเมื่อเลือกใหญ่ขึ้น
                                      height: isSelected
                                          ? 70
                                          : 60, // ขนาดรูปเมื่อเลือกใหญ่ขึ้น
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
                    // ฟอร์มที่แสดงขึ้นมาหลังจากเลือกอารมณ์แล้ว
                    AnimatedOpacity(
                      opacity: showForm ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: showForm ? _buildForm() : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ));
          }

          //ฟังก์ชันสร้างฟอร์ม

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _buildForm() {
    return Column(
      children: [
        Text("$selectedEmotion", // อารมณ์ที่ผู้ใช้เลือก
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Type your daily",
              border: OutlineInputBorder(),
            ),
            onSaved: (String? value) {
              info.dailyText =
                  value ?? ''; // เก็บข้อความที่ผู้ใช้กรอกลงใน StoreData
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

        // ใช้ Padding แยกออกจาก Slider
        const Text("How much level your feeling."),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Slider(
            value: value,
            max: 10,
            divisions: 10, // ถ้าอยากให้มี 10 ระดับ
            label: value.round().toString(),
            onChanged: (double currentValue) {
              setState(() {
                value = currentValue;
                //info.levelEmotion = currentValue as String?;
              });
            },
            onChangeEnd: (double currentValue) {
              info.levelEmotion =
                  currentValue.toString(); // เก็บระดับความรู้สึกลงใน StoreData
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            formKey.currentState!.save();
            // แสดงข้อมูลที่ถูกเก็บ
            print("Selected Emotion: ${info.pathEmotion}");
            print("Daily Text: ${info.dailyText}");
            print("Feeling Level: ${info.levelEmotion}");
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
