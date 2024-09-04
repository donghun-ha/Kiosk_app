import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/model/orders.dart';
import 'package:kiosk_app/view/co_out_detail.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CoOut extends StatefulWidget {
  const CoOut({super.key});

  @override
  State<CoOut> createState() => _CoOutState();
}

class _CoOutState extends State<CoOut> {
  late Future<List<Orders>> _orderResults;
  String searchQuery = ''; // 검색어 상태 변수
  final TextEditingController _searchController =
      TextEditingController(); // 검색 컨트롤러
  final DatabaseHandler _dbHandler =
      DatabaseHandler(); // DatabaseHandler 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _orderResults = _fetchOrders(); // 데이터베이스에서 주문 내역 가져오기
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _orderResults = _fetchFilteredOrders(query); // 검색어에 따른 필터링 결과 가져오기
    });
  }

  Future<List<Orders>> _fetchOrders() async {
    final List<Map<String, dynamic>> queryResult =
        await _dbHandler.queryOrders();
    return queryResult.map((map) => Orders.fromMap(map)).toList();
  }

  Future<List<Orders>> _fetchFilteredOrders(String query) async {
    List<Orders> allOrders = await _fetchOrders();
    if (query.isEmpty) {
      return allOrders;
    } else {
      return allOrders.where((order) {
        return (order.customer_id.contains(query)) ||
            (order.id.toString().contains(query)) ||
            (order.store_id.contains(query));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 60,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff9FDFBD),
          ),
          child: const Center(
            child: Text(
              '출고 관리',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: '검색어를 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Orders>>(
              future: _orderResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No orders available.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Orders order = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            CoOutDetail(order: order),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 4,
                            color: const Color(0xffE7EDD1),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '배송 매장: ${order.store_id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '배송 상태: ${order.state}', // Orders 객체의 state 사용
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
