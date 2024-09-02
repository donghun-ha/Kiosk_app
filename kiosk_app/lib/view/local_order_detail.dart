import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class LocalOrderDetailController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final String orderId;
  final RxMap<String, dynamic> orderDetails = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> orderProducts =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  LocalOrderDetailController({required this.orderId});

  @override
  void onInit() {
    super.onInit();
    loadOrderDetails();
  }

  Future<void> loadOrderDetails() async {
    isLoading.value = true;
    try {
      final Database db = await _databaseHandler.initializeDB();

      final List<Map<String, dynamic>> orderResult = await db.query(
        'orders',
        where: 'id = ?',
        whereArgs: [orderId],
      );

      if (orderResult.isNotEmpty) {
        orderDetails.value = orderResult.first;

        final List<Map<String, dynamic>> productResult = await db.rawQuery('''
          SELECT p.*, o.quantity
          FROM product p
          JOIN orders o ON p.id = o.product_id
          WHERE o.id = ?
        ''', [orderId]);

        orderProducts.value = productResult;
      }
    } catch (e) {
      print('Error loading order details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class LocalOrderDetailPage extends StatelessWidget {
  final String orderId;

  const LocalOrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalOrderDetailController(orderId: orderId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('주문 상세 정보 - $orderId'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.orderDetails.isEmpty) {
          return const Center(child: Text('주문 정보를 찾을 수 없습니다.'));
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('주문 번호: ${controller.orderDetails['id']}',
                    style: Theme.of(context).textTheme.headlineSmall),
                Text('고객 ID: ${controller.orderDetails['customer_id']}'),
                Text('주문 일자: ${controller.orderDetails['date']}'),
                Text('총 금액: ${controller.orderDetails['total_price']}원'),
                Text('픽업 예정일: ${controller.orderDetails['pickup_date']}'),
                const SizedBox(height: 20),
                Text('주문 상품 목록',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.orderProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.orderProducts[index];
                    return Card(
                      child: ListTile(
                        title: Text(product['name']),
                        subtitle: Text(
                            '사이즈: ${product['size']}, 색상: ${product['color']}'),
                        trailing: Text('수량: ${product['quantity']}'),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
