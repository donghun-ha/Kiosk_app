import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class KioskDetail extends StatefulWidget {
  final String orderNumber; // 전달받은 주문번호
  const KioskDetail({super.key, required this.orderNumber});

  @override
  State<KioskDetail> createState() => _KioskDetailState();
}

class _KioskDetailState extends State<KioskDetail> {
  DatabaseHandler handler = DatabaseHandler();

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
      body: FutureBuilder(
        future:
            handler.queryOrderProducts(widget.orderNumber), // 주문 번호에 맞는 제품들 조회
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Image.memory(
                          snapshot.data![index].image,
                          width: 120,
                          height: 120,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '     ${snapshot.data![index].brand} ${snapshot.data![index].name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' Color ${snapshot.data![index].color}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '     재고량 \n     ${snapshot.data![index].stock}EA',
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
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
