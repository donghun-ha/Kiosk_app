import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class KioskDetail extends StatefulWidget {
  const KioskDetail({super.key});

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
        future: handler.queryProduct(), // 나중에 오더 함수로 바꿔줘야함.
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
      // Padding(
      //   padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       // Alert
      //     },
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.black,
      //       foregroundColor: Colors.white,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(8),
      //       ),
      //       fixedSize: const Size(300, 60),
      //     ),
      //     child: const Text(
      //       '제품 수령하기',
      //       style: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      // ),