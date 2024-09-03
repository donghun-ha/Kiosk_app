import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/model/orders.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CoOutDetail extends StatefulWidget {
  final Orders order;

  const CoOutDetail({super.key, required this.order});

  @override
  _CoOutDetailState createState() => _CoOutDetailState();
}

class _CoOutDetailState extends State<CoOutDetail> {
  late Future<List<Product>> _productResults;
  final DatabaseHandler handler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    _productResults = _fetchProductDetails(widget.order.product_id);
  }

  Future<List<Product>> _fetchProductDetails(String productId) async {
    // 데이터베이스에서 제품 정보를 가져옵니다.
    final List<Map<String, dynamic>> queryResult =
        await handler.queryProductById(productId);
    // Map 리스트를 Product 리스트로 변환
    return queryResult.map((map) => Product.fromMap(map)).toList();
  }

  Future<void> _updateOrderState() async {
    // 주문 상태 업데이트
    await handler.updateOrderState(widget.order.id!, '출고 완료');
    setState(() {
      widget.order.state = '출고 완료'; // 상태를 로컬에서도 업데이트
    });
    Get.snackbar(
      '상태 업데이트',
      '주문 상태가 "출고 완료"로 업데이트되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          height: 60,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff9FDFBD),
          ),
          child: Center(
            child: Text(
              '제품 출고: ${widget.order.id}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('픽업매장: ${widget.order.store_id}'),
                  Text('배송상태: ${widget.order.state}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products available.'));
                  } else {
                    return Column(
                      children: [
                        _buildProductTableHeader(),
                        for (var product in snapshot.data!)
                          _buildProductTableRow(
                            product.id,
                            product.color,
                            product.name,
                            product.size.toString(),
                            product.stock.toString(),
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _updateOrderState,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5C4B91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  '출고 완료',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: Colors.grey.shade300,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('품목 ID', textAlign: TextAlign.center)),
          Expanded(child: Text('컬러', textAlign: TextAlign.center)),
          Expanded(child: Text('품목', textAlign: TextAlign.center)),
          Expanded(child: Text('사이즈', textAlign: TextAlign.center)),
          Expanded(child: Text('재고', textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildProductTableRow(
      String id, String color, String name, String size, String stock) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(id, textAlign: TextAlign.center)),
          Expanded(child: Text(color, textAlign: TextAlign.center)),
          Expanded(child: Text(name, textAlign: TextAlign.center)),
          Expanded(child: Text(size, textAlign: TextAlign.center)),
          Expanded(child: Text(stock, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
