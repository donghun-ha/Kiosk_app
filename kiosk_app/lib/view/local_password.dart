import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class LocalPasswordController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      final success = await _databaseHandler.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      if (success) {
        Get.snackbar('성공', '비밀번호가 성공적으로 변경되었습니다.');
        Get.back();
      } else {
        Get.snackbar('오류', '현재 비밀번호가 일치하지 않습니다.');
      }
    }
  }
}

class LocalPasswordPage extends GetView<LocalPasswordController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalPasswordController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('비밀번호 변경'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: controller.currentPasswordController,
              decoration: InputDecoration(labelText: '현재 비밀번호'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '현재 비밀번호를 입력해주세요';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.newPasswordController,
              decoration: InputDecoration(labelText: '새 비밀번호'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '새 비밀번호를 입력해주세요';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.confirmPasswordController,
              decoration: InputDecoration(labelText: '새 비밀번호 확인'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '새 비밀번호를 다시 입력해주세요';
                }
                if (value != controller.newPasswordController.text) {
                  return '새 비밀번호가 일치하지 않습니다';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.changePassword,
              child: Text('비밀번호 변경'),
            ),
          ],
        ),
      ),
    );
  }
}
