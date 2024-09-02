import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/model/orders.dart';
import 'package:kiosk_app/view/co_order_detail.dart'; // 상세 정보 페이지로 이동하기 위해 import

class CoOrder extends StatefulWidget {
  const CoOrder({super.key});

  @override
  State<CoOrder> createState() => _CoOrderState();
}

class _CoOrderState extends State<CoOrder> {
  late Future<List<Orders>> _orderResults;
  String _searchQuery = ''; // 검색어 상태 변수
  final TextEditingController _searchController =
      TextEditingController(); // 검색 컨트롤러

  @override
  void initState() {
    super.initState();
    _orderResults = _fetchExampleOrders(); // 예시 주문 내역 가져오기
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _orderResults = _fetchFilteredOrders(); // 검색어에 따른 필터링 결과 가져오기
    });
  }

  Future<List<Orders>> _fetchExampleOrders() async {
    // 예시 데이터 생성
    return [
      Orders(
        id: 1,
        customer_id: '101',
        product_id: 'a00001250',
        store_id: '301',
        date: '2023-09-01 14:30',
        quantity: 2,
        total_price: 50000,
        pickup_date: '2023-09-02',
        state: 'pending',
      ),
      Orders(
        id: 2,
        customer_id: '102',
        product_id: 'a00002255',
        store_id: '302',
        date: '2023-09-02 10:15',
        quantity: 1,
        total_price: 75000,
        pickup_date: '2023-09-03',
        state: 'pending',
      ),
      Orders(
        id: 3,
        customer_id: '103',
        product_id: 'a00003265',
        store_id: '303',
        date: '2023-09-03 16:45',
        quantity: 3,
        total_price: 120000,
        pickup_date: '2023-09-04',
        state: 'pending',
      ),
    ];
  }

  Future<List<Orders>> _fetchFilteredOrders() async {
    List<Orders> allOrders = await _fetchExampleOrders();
    if (_searchQuery.isEmpty) {
      return allOrders;
    } else {
      return allOrders.where((order) {
        return (order.customer_id.contains(_searchQuery)) ||
            (order.id?.toString().contains(_searchQuery) ?? false) ||
            (order.store_id.contains(_searchQuery));
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
              '주문 관리',
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
                          // 주문 상세 화면으로 이동하며 주문 정보를 전달
                          Get.to(
                            CoOrderDetail(
                                order: order), // CoOrderDetail로 주문 정보 전달
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 4,
                            color: const Color(0xffE7EDD1),
                            child: Container(
                              width: double.infinity, // 카드가 화면 너비에 맞게 확장되도록 설정
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '주문 번호: ${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '회원 번호: ${order.customer_id}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '결제 금액: ${order.total_price}원',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '결제 일시: ${order.date}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
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
