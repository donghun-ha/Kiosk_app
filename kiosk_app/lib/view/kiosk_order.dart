import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/view/kiosk_detail.dart';

class KioskOrder extends StatefulWidget {
  const KioskOrder({super.key});

  @override
  State<KioskOrder> createState() => _KioskOrderState();
}

class _KioskOrderState extends State<KioskOrder> {
  late TextEditingController orderController;

  @override
  void initState() {
    super.initState();
    orderController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 150, 30, 30),
              child: TextField(
                controller: orderController,
                decoration: const InputDecoration(
                  hintText: '주문번호를 입력해주십시오.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  String orderNumber = orderController.text.trim(); // 입력값 가져오기
                  if (orderNumber.isEmpty) {
                    // 주문번호가 입력되지 않았을 경우
                    Get.snackbar(
                      '입력 오류',
                      '주문번호를 입력해주세요.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    // 주문번호가 입력된 경우
                    Get.to(() => KioskDetail(orderNumber: orderNumber));
                  }
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
                  '확인',
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
    );
  }
}
