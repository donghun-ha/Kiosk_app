import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiosk_app/model/customer.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  // Property
  late DatabaseHandler handler;
  late TextEditingController idController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    'ID 입력',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(174, 0, 0, 0),
                    child: Text(
                      '아이디 중복 확인',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      checkDuplicatedId();
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  hintText: 'ID를 6~12자까지 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                maxLength: 12,
              ),
              const Row(
                children: [
                  Text(
                    'Password 입력',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password를 8자이상 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const Row(
                children: [
                  Text(
                    'Password 확인',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: TextField(
                  controller: passwordConfirmController,
                  decoration: const InputDecoration(
                    hintText: 'password를 다시 한 번 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const Row(
                children: [
                  Text(
                    '이름',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: '이름을 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              const Row(
                children: [
                  Text(
                    '휴대폰 번호',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: '휴대폰 번호를 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       getImageFromGallery(ImageSource.gallery);
              //     },
              //     child: const Text('Gallery'),
              //   ),
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: 200,
              //   color: Colors.grey,
              //   child: Center(
              //     child: imageFile == null
              //         ? const Text('Image is not selected.')
              //         : Image.file(File(imageFile!.path)),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    insertAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fixedSize: const Size(300, 60),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- functions ---

  // 아이디 중복 확인 함수 추가
  Future checkDuplicatedId() async {
    String id = idController.text.trim();
    List<Customer> existingCustomers = await handler.queryCustomersById(id);

    if (existingCustomers.isNotEmpty) {
      Get.snackbar("오류", "이미 존재하는 아이디입니다.",
          snackPosition: SnackPosition.TOP,
          colorText: Theme.of(context).colorScheme.onError,
          backgroundColor: Theme.of(context).colorScheme.error);
    } else {
      Get.snackbar("성공", "사용 가능한 아이디입니다.",
          snackPosition: SnackPosition.TOP,
          colorText: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary);
    }
  }
  // Future getImageFromGallery(ImageSource imageSource) async {
  //   final XFile? pickerFile = await picker.pickImage(source: imageSource);
  //   if (pickerFile == null) {
  //     return;
  //   } else {
  //     imageFile = XFile(pickerFile.path);
  //     setState(() {});
  //   }
  // }

  // 아이디 중복확인 후 회원가입
  Future insertAction() async {
    // // File Type을 byte Type으로 변환하기
    // File imageFile1 = File(imageFile!.path);
    // imageFile1.readAsBytes();
    List<Customer> existingCustomers =
        await handler.queryCustomersById(idController.text.trim());
    if (existingCustomers.isNotEmpty) {
      Get.snackbar("오류", "이미 존재하는 아이디입니다.",
          snackPosition: SnackPosition.TOP,
          colorText: Theme.of(context).colorScheme.onError,
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }

    if (passwordController.text.trim() !=
        passwordConfirmController.text.trim()) {
      errorSnackBar();
      return;
    }

    var customerInsert = Customer(
      id: idController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      // image: getImage,
    );
    int result = await handler.insertCustomer(customerInsert);

    if (result > 0) {
      _showDialog();
    }
  }

  _showDialog() {
    Get.defaultDialog(
        title: '회원가입',
        middleText: '축하합니다 회원가입이 완료되었습니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'),
          ),
        ]);
  }

  errorSnackBar() {
    Get.snackbar("오류", "비밀번호가 일치하지 않습니다.",
        snackPosition: SnackPosition.TOP,
        colorText: Theme.of(context).colorScheme.onError,
        backgroundColor: Theme.of(context).colorScheme.error);
  }
} // End
