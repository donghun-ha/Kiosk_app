// kiosk_order.dart

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              height: 100,
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
            const SizedBox(height: 20),
            const Text(
              '1. 앱으로 주문을 완료하셨나요? \n 앱에서 주문 번호를 확인하세요.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "2. 키오스크에서 주문 확인 \n 아래에 주문 번호를 입력하고, \n '확인' 버튼을 눌러주세요.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '3. 매장 직원에게 알림',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '주문이 확인되면, 매장 직원이 준비된 제품을 전달해 드립니다.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
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
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
