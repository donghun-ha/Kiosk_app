import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:kiosk_app/view/local_invent_detail.dart';
import 'package:kiosk_app/view/local_profile.dart';

class LocalInventPage extends StatefulWidget {
  const LocalInventPage({super.key});

  @override
  _LocalInventPageState createState() => _LocalInventPageState();
}

class _LocalInventPageState extends State<LocalInventPage> {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final searchController = TextEditingController();
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredProducts =
      <Map<String, dynamic>>[].obs;
  final RxString searchType = '제품명'.obs;
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
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
        return '${double.parse(price.replaceAll(',', '')).toStringAsFixed(2)}원';
      } catch (e) {
        return '$price원';
      }
    }
    return '$price원';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: const Text('상품 재고'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Get.to(() => const LocalProfilePage());
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
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: '${searchType.value} 검색',
                      suffixIcon: const Icon(Icons.search),
                    ),
                    onChanged: filterProducts,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String value) {
                    searchType.value = value;
                    filterProducts(searchController.text);
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(value: '제품명', child: Text('제품명')),
                    const PopupMenuItem(value: '브랜드', child: Text('브랜드')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (filteredProducts.isEmpty) {
                return const Center(child: Text('검색 결과가 없습니다'));
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                  ),
                  padding: const EdgeInsets.all(35),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => LocalInventDetailPage(
                              productName: product['name'].toString(),
                            ));
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FutureBuilder<Uint8List?>(
                                future: _databaseHandler
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
                                    return const Center(
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                      '평균 가격: ${formatPrice(product['avg_price'])}'),
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
