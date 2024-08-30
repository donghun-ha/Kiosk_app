import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class LocalOrderDetailPage extends StatefulWidget {
  final String orderId;

  const LocalOrderDetailPage({super.key, required this.orderId});

  @override
  _LocalOrderDetailPageState createState() => _LocalOrderDetailPageState();
}

class _LocalOrderDetailPageState extends State<LocalOrderDetailPage> {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  Map<String, dynamic>? _orderDetails;
  List<Map<String, dynamic>> _orderProducts = [];

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    final Database db = await _databaseHandler.initializeDB();

    // 주문 상세 정보 가져오기
    final List<Map<String, dynamic>> orderResult = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [widget.orderId],
    );

    if (orderResult.isNotEmpty) {
      setState(() {
        _orderDetails = orderResult.first;
      });

      // 주문한 제품 목록 가져오기
      final List<Map<String, dynamic>> productResult = await db.rawQuery('''
        SELECT p.*, o.quantity
        FROM product p
        JOIN orders o ON p.id = o.product_id
        WHERE o.id = ?
      ''', [widget.orderId]);

      setState(() {
        _orderProducts = productResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('주문 상세 정보 - ${widget.orderId}'),
      ),
      body: _orderDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('주문 번호: ${_orderDetails!['id']}',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text('고객 ID: ${_orderDetails!['customer_id']}'),
                  Text('주문 일자: ${_orderDetails!['date']}'),
                  Text('총 금액: ${_orderDetails!['total_price']}원'),
                  Text('픽업 예정일: ${_orderDetails!['pickup_date']}'),
                  const SizedBox(height: 20),
                  Text('주문 상품 목록',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _orderProducts.length,
                    itemBuilder: (context, index) {
                      final product = _orderProducts[index];
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
            ),
    );
  }
}
