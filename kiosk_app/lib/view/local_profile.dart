import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/view/local_modify.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'dart:typed_data';

class LocalProfileController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final Rx<Map<String, dynamic>> user = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final userData = await _databaseHandler.getCurrentUser();
      user.value = userData;
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class LocalProfilePage extends StatelessWidget {
  const LocalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: const Text('프로필'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.user.value.isEmpty) {
          return const Center(child: Text('사용자 정보를 찾을 수 없습니다.'));
        }

        final user = controller.user.value;
        return Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: user['image'] != null
                  ? MemoryImage(user['image'] as Uint8List)
                  : const AssetImage('images/default_profile.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(user['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.to(() => LocalModifyPage());
              },
              child: Text('프로필 수정'),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('ID'),
              subtitle: Text(user['id']),
            ),
            ListTile(
              title: const Text('휴대폰 번호'),
              subtitle: Text(user['phone']),
            ),
            ListTile(
              title: const Text('매장 번호'),
              subtitle: Text(user['store_id'] ?? '없음'),
            ),
          ],
        );
      }),
    );
  }
}
