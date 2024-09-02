import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerCart extends StatefulWidget {
  const CustomerCart({super.key});

  @override
  State<CustomerCart> createState() => _CustomerCartState();
}

class _CustomerCartState extends State<CustomerCart> {
  late int orderId;
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    orderId = 0;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
              future: handler.quaryOrders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  orderId = snapshot.data![snapshot.data!.length - 1]['id'];
                  return Column(
                    children: [
                      Image.memory(
                        snapshot.data![snapshot.data!.length - 1]['image'],
                        width: 400,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data![snapshot.data!.length - 1]['brand'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data![snapshot.data!.length - 1]['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        snapshot.data![snapshot.data!.length - 1]['color'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${snapshot.data![snapshot.data!.length - 1]['size']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '총 수량 : ${snapshot.data![snapshot.data!.length - 1]['quantity']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '주문일 : ${snapshot.data![snapshot.data!.length - 1]['date']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '총 금액 : ${snapshot.data![snapshot.data!.length - 1]['total_price']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffDCB21C)),
                      ),
                      Text(
                        '수령지점 : ${snapshot.data![snapshot.data!.length - 1]['sname']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
              child: SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      getprice(orderId);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6644AB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getprice(int id) async {
    await handler.updateOrders(id);
  }
}
