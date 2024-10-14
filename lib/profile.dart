import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // รูปโปรไฟล์
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage('assets/images/profilePic.jpg'), // ใส่รูปใน assets
            ),
            SizedBox(height: 16),

            // ชื่อผู้ใช้
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // อีเมล
            Text(
              'johndoe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),

            // ข้อมูลเพิ่มเติม
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone Number'),
              subtitle: Text('+1 234 567 890'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Location'),
              subtitle: Text('New York, USA'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text('Birthday'),
              subtitle: Text('January 1, 1990'),
            ),
          ],
        ),
      ),
    );
  }
}
