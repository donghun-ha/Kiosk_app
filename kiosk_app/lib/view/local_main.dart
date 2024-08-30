import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class LocalMainPage extends StatefulWidget {
  const LocalMainPage({super.key});

  @override
  _LocalMainPageState createState() => _LocalMainPageState();
}

class _LocalMainPageState extends State<LocalMainPage> {
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  String _storeName = 'Loading...';
  int _pickupRequestCount = 0;
  int _todayPickupCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoes Maker'),
        backgroundColor: const Color(0xFFF0FFF5),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/local_profile');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 70),
            // 대시보드
            Container(
              width: 350,
              height: 400,
              decoration: BoxDecoration(
                color: const Color(0xFFC3EDCC),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _storeName,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 76),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // 연한 회색 배경
                        borderRadius: BorderRadius.circular(8), // 모서리를 둥글게
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('픽업 신청', style: TextStyle(fontSize: 18)),
                                Text('$_pickupRequestCount 건',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey[400]), // 구분선 추가
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('당일 픽업', style: TextStyle(fontSize: 18)),
                                Text('$_todayPickupCount 건',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // 버튼 row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/local_order');
                  },
                  text: '주문 내역',
                  icon: Icons.list_alt,
                  color: Colors.blue,
                ),
                const SizedBox(width: 20),
                _buildSquareButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/local_invent');
                  },
                  text: '상품 재고',
                  icon: Icons.inventory,
                  color: const Color.fromARGB(255, 136, 204, 139),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    try {
      await _databaseHandler.printAllOrders(); // 모든 주문 출력
      await _databaseHandler.checkDates(); // 날짜 확인

      final storeName = await _databaseHandler.getStoreName();
      final pickupRequestCount = await _databaseHandler.getPickupRequestCount();
      final todayPickupCount = await _databaseHandler.getTodayPickupCount();

      print('Store Name: $storeName');
      print('Pickup Request Count: $pickupRequestCount');
      print('Today Pickup Count: $todayPickupCount');

      setState(() {
        _storeName = storeName;
        _pickupRequestCount = pickupRequestCount;
        _todayPickupCount = todayPickupCount;
      });
    } catch (e) {
      print('Error loading data: $e');
      // 에러 처리 (예: 사용자에게 알림)
    }
  }

  Widget _buildSquareButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 140, // 버튼의 너비
      height: 140, // 버튼의 높이
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0XFF3A895F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 모서리를 둥글게
          ),
          padding: EdgeInsets.all(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 15),
            Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
