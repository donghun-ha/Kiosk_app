import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:kiosk_app/model/product.dart';

class KioskDetail extends StatefulWidget {
  final String orderNumber;

  const KioskDetail({super.key, required this.orderNumber});

  @override
  _KioskDetailState createState() => _KioskDetailState();
}

class _KioskDetailState extends State<KioskDetail> {
  DatabaseHandler handler = DatabaseHandler();
  late Future<List<Map<String, dynamic>>> _orderProducts;

  @override
  void initState() {
    super.initState();
    _orderProducts = handler.queryOrderProducts(widget.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '주문 제품',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _orderProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var productData = snapshot.data![index];
                Product product = Product.fromMap(productData);
                int quantity = productData['quantity'] ?? 0; // 구매 수량

                return Column(
                  children: [
                    Row(
                      children: [
                        Image.memory(
                          product.image,
                          width: 120,
                          height: 120,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '     (${product.brand}) ${product.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Color: ${product.color}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Size: ${product.size}', // 사이즈 추가
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '     구매 수량: $quantity EA',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
