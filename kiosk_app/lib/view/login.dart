import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/view/co_main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController idController;
  late TextEditingController passwordCotroller;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passwordCotroller = TextEditingController();
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
              controller: passwordCotroller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              //
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
                  //
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
              Get.to(const CoMain());
              // 작업용 본사 메인페이지 보내기용 추후 변경 예정.
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
}
