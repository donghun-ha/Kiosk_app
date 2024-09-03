import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerCart extends StatefulWidget {
  const CustomerCart({super.key});

  @override
  State<CustomerCart> createState() => _CustomerCartState();
}

class _CustomerCartState extends State<CustomerCart> {
  late DatabaseHandler handler;
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    _ordersFuture = handler.quaryOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEBE8E8),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Item in cart',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No orders available');
            } else {
              final latestOrder = snapshot.data!.last;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.memory(
                    latestOrder['image'],
                    width: 400,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${latestOrder['brand']} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        latestOrder['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    latestOrder['color'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${latestOrder['size']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '총 수량 : ${latestOrder['quantity']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '주문일 : ${latestOrder['date']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '총 금액 : ${latestOrder['total_price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffDCB21C),
                    ),
                  ),
                  Text(
                    '수령지점 : ${latestOrder['sname']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
                    child: SizedBox(
                      width: 300,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => _updateOrder(latestOrder['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6644AB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _updateOrder(int id) async {
    try {
      await handler.updateOrders(id);
      setState(() {
        _ordersFuture = handler.quaryOrders(); // Refresh orders
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order: $e')),
      );
    }
  }
}
