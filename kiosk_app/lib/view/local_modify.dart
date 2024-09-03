import 'dart:typed_data';
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:kiosk_app/view/local_password.dart';

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
  const LocalModifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalModifyController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: const Text('프로필 수정'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
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
                        : const AssetImage('images/default_profile.png')
                            as ImageProvider,
                  )),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: '이름'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.phoneController,
              decoration: const InputDecoration(labelText: '휴대폰 번호'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '휴대폰 번호를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const LocalPasswordPage());
              },
              child: const Text('비밀번호 변경'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: controller.updateProfile,
              child: const Text('프로필 수정'),
            ),
          ],
        ),
      ),
    );
  }
}

// 웹 지원을 위한 전역 변수
const bool kIsWeb = identical(0, 0.0);
