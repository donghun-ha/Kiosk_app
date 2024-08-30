import 'dart:typed_data';
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class LocalModifyController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final Rx<XFile?> image = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = await _databaseHandler.getCurrentUser();
    nameController.text = user['name'];
    phoneController.text = user['phone'];
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image.value = pickedImage;
    }
  }

  Future<void> updateProfile() async {
    if (formKey.currentState!.validate()) {
      Uint8List? imageBytes;
      if (image.value != null) {
        imageBytes = await image.value!.readAsBytes();
      }
      await _databaseHandler.updateUserProfile(
        name: nameController.text,
        phone: phoneController.text,
        image: imageBytes,
      );
      Get.back();
    }
  }
}

class LocalModifyPage extends GetView<LocalModifyController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalModifyController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('프로필 수정'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.image.value != null
                        ? kIsWeb
                            ? NetworkImage(controller.image.value!.path)
                            : FileImage(File(controller.image.value!.path))
                                as ImageProvider
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider,
                  )),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(labelText: '이름'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.phoneController,
              decoration: InputDecoration(labelText: '휴대폰 번호'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '휴대폰 번호를 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/local_password'),
              child: Text('비밀번호 변경'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: controller.updateProfile,
              child: Text('프로필 수정'),
            ),
          ],
        ),
      ),
    );
  }
}

// 웹 지원을 위한 전역 변수
final bool kIsWeb = identical(0, 0.0);
