import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:kiosk_app/view/local_order_detail.dart';
import 'package:kiosk_app/view/local_profile.dart';

class LocalOrderController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> allOrders = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredOrders =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final orders = await _databaseHandler.getOrders();
      allOrders.value = orders;
      filteredOrders.value = orders;
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterOrders() {
    if (searchController.text.isEmpty) {
      filteredOrders.value = allOrders;
    } else {
      filteredOrders.value = allOrders.where((order) {
        return order['customer_id']
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    }
  }
}

class LocalOrderPage extends GetView<LocalOrderController> {
  const LocalOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalOrderController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: const Text('주문 내역'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocalProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                labelText: '회원 ID 검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: controller.filterOrders,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (_) => controller.filterOrders(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.filteredOrders.isEmpty) {
                return const Center(child: Text('검색 결과가 없습니다.'));
              } else {
                return ListView.builder(
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LocalOrderDetailPage(orderId: order['id']),
                          ),
                        );
                      },
                      child: OrderCard(order: order),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('회원 ID: ${order['customer_id']}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('주문번호: ${order['id']}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('상품 ID: ${order['product_id']}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('주문일시: ${order['date']}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('수량: ${order['quantity']}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('주문금액: ${order['total_price']}원',
                  style: const TextStyle(fontSize: 16, color: Colors.blue)),
              const SizedBox(height: 4),
              Text('픽업 날짜: ${order['pickup_date']}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
