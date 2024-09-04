import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerPassword extends StatefulWidget {
  const CustomerPassword({super.key});

  @override
  State<CustomerPassword> createState() => _CustomerPasswordState();
}

class _CustomerPasswordState extends State<CustomerPassword> {
  late DatabaseHandler handler;
  late TextEditingController nowpasswordController;
  late TextEditingController newpasswordController;
  late TextEditingController checkpasswordController;
  var value = Get.arguments ?? '__';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    nowpasswordController = TextEditingController();
    newpasswordController = TextEditingController();
    checkpasswordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Padding(
                    padding: EdgeInsets.fromLTRB(30, 70, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          '현재 비밀번호',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                          ),
                      ],
                    ),
                  ),
            Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextField(
                      controller: nowpasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '현재 비밀번호 입력',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 190, 190, 190),
                            width: 1
                          )
                        )
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          '새 비밀번호',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                          ),
                      ],
                    ),
                  ),
            Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextField(
                      controller: newpasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '새 비밀번호 입력',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 190, 190, 190),
                            width: 1
                          )
                        )
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          '비밀번호 확인',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                          ),
                      ],
                    ),
                  ),
            Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextField(
                      controller: checkpasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '비밀번호 확인',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 190, 190, 190),
                            width: 1
                          )
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: SizedBox(
                      width: 300,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          showAlert(value[0], newpasswordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFF4D4D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        child: const Text(
                          '비밀번호 변경',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      width: 300,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                        child: const Text(
                            '변경 취소',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                            )
                        ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future updatePassword(String id, String password)async{
    await handler.updateCustomerPassword(id, password);
  }

  showAlert(String id, String password){
    Get.defaultDialog(
      titleStyle: const TextStyle(
        color: Colors.black
      ),
      middleTextStyle: const TextStyle(
        color: Colors.black
      ),
      title: '비밀번호 변경',
      middleText: '정말로 변경하시겠습니까?',
      barrierDismissible: false,
      backgroundColor: Colors.white,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          }, 
          child: const Text(
            '취소',
            style: TextStyle(
              color: Colors.red
            ),
            )
          ),
        TextButton(
          onPressed: () {
            if(nowpasswordController.text.trim().isEmpty || nowpasswordController.text.trim() != value[1]){
              showSnackBarNow();
            }else{
            if(newpasswordController.text.trim().isEmpty || checkpasswordController.text.trim().isEmpty){
                showSnackBarNew();
              }else if(newpasswordController.text.trim() != checkpasswordController.text.trim()){
                showSnackBarNew();
              }else{
              updatePassword(id, password);
              Get.back();
              Get.back();
              setState(() {});
              }
              
            }
          }, 
          child: const Text(
            '변경',
            style: TextStyle(
              color: Colors.black
            ),
            )
          ),
      ]
    );
  }

  showSnackBarNow(){
    Get.snackbar(
      '경고', 
      '현재 비밀번호가 틀렸거나 칸이 비어있습니다.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
      backgroundColor: Theme.of(context).colorScheme.onError,
      colorText: Colors.white
      );
  }
  showSnackBarNew(){
    Get.snackbar(
      '경고', 
      '새 비밀번호가 비밀번호 확인과 같지 않거나 칸이 비어있습니다.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
      backgroundColor: Theme.of(context).colorScheme.onError,
      colorText: Colors.white
      );
  }
}