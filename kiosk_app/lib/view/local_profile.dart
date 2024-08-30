import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class LocalProfilePage extends StatelessWidget {
  final DatabaseHandler _databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('프로필'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _databaseHandler.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('사용자 정보를 찾을 수 없습니다.'));
          }

          final user = snapshot.data!;
          return Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: user['image'] != null
                    ? MemoryImage(user['image'])
                    : AssetImage('images/default_profile.png') as ImageProvider,
              ),
              SizedBox(height: 10),
              Text(user['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/local_modify');
                },
                child: Text('프로필 수정'),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('ID'),
                subtitle: Text(user['id']),
              ),
              ListTile(
                title: Text('휴대폰 번호'),
                subtitle: Text(user['phone']),
              ),
              ListTile(
                title: Text('매장 번호'),
                subtitle: Text(user['store_id'] ?? '없음'),
              ),
            ],
          );
        },
      ),
    );
  }
}
