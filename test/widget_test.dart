import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_mood_app/add_emo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_mood_app/main.dart';
import 'package:mockito/mockito.dart';

//class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  setUpAll(() async {
    // Mock Firebase for testing
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Example test', (WidgetTester tester) async {
    // ใช้ MockFirebaseFirestore แทน Firebase จริง
    final firestore = MockFirebaseFirestore();

    // เริ่มทดสอบโดยไม่ต้องใช้ Firebase จริง
    await tester.pumpWidget(MyApp());

    // ทดสอบ widget logic ของคุณได้ตามปกติ
    expect(find.text('0'), findsOneWidget);
  });
}
