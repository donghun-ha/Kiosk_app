import 'package:flutter/material.dart';
import 'package:kiosk_app/model/orders.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CoOrderDetail extends StatefulWidget {
  final Orders order;

  const CoOrderDetail({super.key, required this.order});

  @override
  _CoOrderDetailState createState() => _CoOrderDetailState();
}

class _CoOrderDetailState extends State<CoOrderDetail> {
  late Future<List<Product>> _productResults;
  final DatabaseHandler handler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    _productResults = _fetchProductDetails(widget.order.product_id);
  }

  Future<List<Product>> _fetchProductDetails(String productId) async {
    // 데이터베이스에서 제품 정보를 가져옵니다.
    final List<Map<String, dynamic>> queryResult = await handler
        .queryProductById(productId); // productId에 해당하는 제품 정보를 가져옵니다.
    // Map 리스트를 Product 리스트로 변환
    return queryResult.map((map) => Product.fromMap(map)).toList();
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
              '주문 상세: ${widget.order.id}',
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
                  Text('주문 번호: ${widget.order.id}'),
                  Text('회원 번호: ${widget.order.customer_id}'),
                  Text('결제 금액: ${widget.order.total_price}원'),
                  Text('결제 일시: ${widget.order.date}'),
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
