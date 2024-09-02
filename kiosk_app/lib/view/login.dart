import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/view/co_main.dart';
import 'package:kiosk_app/view/kiosk_order.dart';
import 'package:kiosk_app/view/local_main.dart';
import 'package:kiosk_app/view/sign.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late DatabaseHandler handler;
  late TextEditingController idController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 400,
            height: 230,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SHOE',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: 70,
                  color: Colors.black,
                  child: const Text(
                    'MARKET',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: Row(
              children: [
                Text(
                  'ID',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
            child: TextField(
              controller: idController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Row(
              children: [
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              obscureText: true,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              handleLogin();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fixedSize: const Size(230, 50),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '아이디가 없으신가요?',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(const Sign());
                  idController.clear();
                  passwordController.clear();
                },
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    color: Color.fromARGB(255, 115, 83, 158),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              kioskLogin();
              idController.clear();
              passwordController.clear();
            },
            child: const Text(
              'Kiosk Login',
              style: TextStyle(
                color: Color.fromARGB(255, 115, 83, 158),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Funtions ---
  handleLogin() async {
    if (idController.text.trim() == 'main' &&
        passwordController.text.trim() == 'qwer1234') {
      Get.to(const CoMain());
      idController.clear();
      passwordController.clear();
      return;
    }
    if (idController.text.trim() == 'store001' &&
        passwordController.text.trim() == 'qwer1234') {
      Get.to(const LocalMain());
      idController.clear();
      passwordController.clear();
      return;
    }

    // 고객 계정 확인
    final customer = await handler.fetchCustomerByIdAndPassword(
      idController.text.trim(),
      passwordController.text.trim(),
    );

    if (customer != null) {
      // 고객 정보가 존재하면 고객용 페이지로 이동
      Get.to(const LocalMain());
      idController.clear();
      passwordController.clear();
    } else {
      // 로그인 실패 시 오류 메시지 표시
      Get.snackbar(
        "로그인 실패",
        "아이디 또는 비밀번호가 잘못되었습니다.",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  kioskLogin() async {
    final customer = await handler.fetchCustomerByIdAndPassword(
      idController.text.trim(),
      passwordController.text.trim(),
    );

    if (customer != null) {
      // 고객 정보가 존재하면 고객용 페이지로 이동
      Get.to(const KioskOrder());
      idController.clear();
      passwordController.clear();
    } else {
      // 로그인 실패 시 오류 메시지 표시
      Get.snackbar(
        "로그인 실패",
        "아이디 또는 비밀번호가 잘못되었습니다.",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}// End
