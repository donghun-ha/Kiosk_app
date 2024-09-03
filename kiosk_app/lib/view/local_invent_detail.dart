import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'dart:typed_data';

class LocalInventDetailController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final String productName;
  final RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  final Rx<Uint8List?> productImage = Rx<Uint8List?>(null);
  final RxBool isLoading = true.obs;

  LocalInventDetailController({required this.productName});

  @override
  void onInit() {
    super.onInit();
    loadProductDetails();
  }

  Future<void> loadProductDetails() async {
    isLoading.value = true;
    try {
      final productItems = await _databaseHandler.getProductItems(productName);
      items.value = productItems;
      if (items.isNotEmpty) {
        productImage.value = await _databaseHandler
            .getProductImage(items.first['id'].toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  String formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    if (price is num) {
      return '${price.toStringAsFixed(0)}원';
    }
    if (price is String) {
      try {
        return '${int.parse(price).toStringAsFixed(0)}원';
      } catch (e) {
        return '$price원';
      }
    }
    return '$price원';
  }
}

class LocalInventDetailPage extends GetView<LocalInventDetailController> {
  final String productName;

  LocalInventDetailPage({super.key, required this.productName}) {
    Get.put(LocalInventDetailController(productName: productName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: const Text('상품 재고 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Get.toNamed('/local_profile'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.items.isEmpty) {
          return const Center(
              child: Text('No data available for this product'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                productName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              if (controller.productImage.value != null) {
                return Image.memory(
                  controller.productImage.value!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                );
              } else {
                return const Icon(Icons.image_not_supported, size: 200);
              }
            }),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('${item['color']} - ${item['size']}'),
                      subtitle: Text('품목 ID: ${item['id']}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('재고: ${item['stock']}'),
                          Text('가격: ${controller.formatPrice(item['price'])}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
