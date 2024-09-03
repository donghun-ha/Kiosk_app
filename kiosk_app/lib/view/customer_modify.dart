import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/view/customer_password.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerModify extends StatefulWidget {
  const CustomerModify({super.key});

  @override
  State<CustomerModify> createState() => _CustomerModifyState();
}

class _CustomerModifyState extends State<CustomerModify> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late DatabaseHandler handler;
  var value = Get.arguments ?? '__';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    nameController = TextEditingController(text: value[0]);
    phoneController = TextEditingController(text: value[1]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      
                    }, 
                    child: const Text('수정')
                    ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          '이름',
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
                      controller: nameController,
                      decoration: const InputDecoration(
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
                          '휴대폰 번호',
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
                      controller: phoneController,
                      decoration: const InputDecoration(
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
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: SizedBox(
                      width: 300,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const CustomerPassword(),
                          arguments: [
                            value[2],
                            value[3]
                          ])!.then((value) => reloadData());
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
                          showAlert(nameController.text, phoneController.text, value[2]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6644AB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        child: const Text(
                          '프로필 수정',
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
                            '수정 취소',
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
            )
    );
  }
  Future updateProfile(String name, String phone, String id)async{
    await handler.updateCustomerProfile(id, name, phone);
  }

  showAlert(String name, String phone, String id){
    Get.defaultDialog(
      titleStyle: const TextStyle(
        color: Colors.black
      ),
      middleTextStyle: const TextStyle(
        color: Colors.black
      ),
      title: '수정',
      middleText: '정말로 수정하시겠습니까?',
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
            if(nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty){
              Get.back();
              showSnackBar();
            }else{
              updateProfile(name, phone, id);
              Get.back();
              Get.back();
              setState(() {});
            }
          }, 
          child: const Text(
            '수정',
            style: TextStyle(
              color: Colors.black
            ),
            )
          ),
      ]
    );
  }

  showSnackBar(){
    Get.snackbar(
      '경고', 
      '수정칸이 비어있습니다.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
      backgroundColor: Theme.of(context).colorScheme.onError,
      colorText: Colors.white
      );
  }
  reloadData(){
    setState(() {});
  }
}