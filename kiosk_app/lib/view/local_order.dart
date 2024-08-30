import 'package:flutter/material.dart';

import 'package:kiosk_app/vm/database_handler.dart';

class LocalOrderPage extends StatefulWidget {
  const LocalOrderPage({super.key});

  @override
  State<LocalOrderPage> createState() => _LocalOrderPageState();
}

class _LocalOrderPageState extends State<LocalOrderPage> {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allOrders = [];
  List<Map<String, dynamic>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    final orders = await _databaseHandler.getOrders();
    setState(() {
      _allOrders = orders;
      _filteredOrders = [];
    });
  }

  void _filterOrders() {
    setState(() {
      _filteredOrders = _allOrders.where((order) {
        return order['customer_id']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: const Text('주문 내역'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/local_profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '회원 ID 검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _filterOrders,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (_) => _filterOrders(),
            ),
          ),
          Expanded(
            child: _searchController.text.isEmpty
                ? const Center(child: Text('회원 ID를 검색하세요.'))
                : _filteredOrders.isEmpty
                    ? const Center(child: Text('검색 결과가 없습니다.'))
                    : ListView.builder(
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = _filteredOrders[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/local_order_detail',
                                arguments: order['id'],
                              );
                            },
                            child: OrderCard(order: order),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

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
