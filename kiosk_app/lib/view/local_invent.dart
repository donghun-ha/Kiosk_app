import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:kiosk_app/view/local_invent_detail.dart';
import 'package:kiosk_app/view/local_profile.dart';

class LocalInventController extends GetxController {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final searchController = TextEditingController();
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredProducts =
      <Map<String, dynamic>>[].obs;
  final RxString searchType = '제품명'.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final loadedProducts = await _databaseHandler.getProductsSummary();
      products.value = loadedProducts;
      filteredProducts.value = loadedProducts;
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    query = query.trim().toLowerCase();
    if (query.isEmpty) {
      filteredProducts.value = products;
      return;
    }

    filteredProducts.value = products.where((product) {
      final searchField = searchType.value == '제품명' ? 'name' : 'brand';
      final fieldValue = product[searchField]?.toString().toLowerCase() ?? '';
      return fieldValue.contains(query);
    }).toList();
  }

  String formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    if (price is num) return '${price.toStringAsFixed(2)}원';
    if (price is String) {
      try {
        return '${double.parse(price).toStringAsFixed(2)}원';
      } catch (e) {
        return '${price}원';
      }
    }
    return '${price}원';
  }
}

class LocalInventPage extends GetView<LocalInventController> {
  LocalInventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocalInventController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('상품 재고'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
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
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      labelText: '${controller.searchType.value} 검색',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: controller.filterProducts,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    controller.searchType.value = value;
                    controller.filterProducts(controller.searchController.text);
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(value: '제품명', child: Text('제품명')),
                    PopupMenuItem(value: '브랜드', child: Text('브랜드')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.filteredProducts.isEmpty) {
                return Center(child: Text('검색 결과가 없습니다'));
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                  ),
                  padding: EdgeInsets.all(35),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocalInventDetailPage(
                              productName: product['name'].toString(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FutureBuilder<Uint8List?>(
                                future: controller._databaseHandler
                                    .getProductImage(product['id'].toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data != null) {
                                    return Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    );
                                  } else {
                                    return Center(
                                        child: Icon(Icons.image_not_supported,
                                            size: 50));
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] ?? 'No name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '브랜드: ${product['brand'] ?? 'N/A'}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                      '총 재고: ${product['total_stock'] ?? 'N/A'}'),
                                  Text(
                                      '평균 가격: ${controller.formatPrice(product['avg_price'])}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
