import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:kiosk_app/view/local_order.dart';
import 'package:kiosk_app/view/local_invent.dart';
import 'package:kiosk_app/view/local_profile.dart';

class LocalMainController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final RxString storeName = 'Loading...'.obs;
  final RxInt pickupRequestCount = 0.obs;
  final RxInt todayPickupCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      await _databaseHandler.printAllOrders();
      await _databaseHandler.checkDates();

      storeName.value = await _databaseHandler.getStoreName();
      pickupRequestCount.value = await _databaseHandler.getPickupRequestCount();
      todayPickupCount.value = await _databaseHandler.getTodayPickupCount();
    } catch (e) {
      print('Error loading data: $e');
    }
  }
}

class LocalMain extends GetView<LocalMainController> {
  const LocalMain({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalMainController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoes Maker'),
        backgroundColor: const Color(0xFFF0FFF5),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LocalProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Container(
              width: 350,
              height: 400,
              decoration: BoxDecoration(
                color: const Color(0xFFC3EDCC),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(() => Text(
                          controller.storeName.value,
                          style: const TextStyle(
                              fontSize: 34, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 76),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('픽업 신청',
                                    style: TextStyle(fontSize: 18)),
                                Obx(() => Text(
                                      '${controller.pickupRequestCount.value} 건',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey[400]),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('당일 픽업',
                                    style: TextStyle(fontSize: 18)),
                                Obx(() => Text(
                                      '${controller.todayPickupCount.value} 건',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocalOrderPage()),
                    );
                  },
                  text: '주문 내역',
                  icon: Icons.list_alt,
                  color: Colors.blue,
                ),
                const SizedBox(width: 20),
                _buildSquareButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocalInventPage()),
                    );
                  },
                  text: '상품 재고',
                  icon: Icons.inventory,
                  color: const Color.fromARGB(255, 136, 204, 139),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 140,
      height: 140,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF3A895F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 15),
            Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
