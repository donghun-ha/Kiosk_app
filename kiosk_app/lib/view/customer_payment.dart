import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerPayment extends StatefulWidget {
  const CustomerPayment({super.key});

  @override
  State<CustomerPayment> createState() => _CustomerPaymentState();
}

class _CustomerPaymentState extends State<CustomerPayment> {
  late DatabaseHandler handler;
  late List<String> shoeName;
  late List<String> shoePrice;
  late List<String> shoeImage;
  late List<Color> buttonColor;
  late Color firstButtonColor;
  late Color secondButtonColor;
  late int count;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    shoeName = ['나이키 에어'];
    shoePrice = ['100000'];
    shoeImage = ['사진'];
    count = 1;
    buttonColor = [
      const Color(0xff6644AB),
      const Color.fromARGB(255, 186, 167, 225)
    ];
    firstButtonColor = const Color(0xff6644AB);
    secondButtonColor = const Color.fromARGB(255, 186, 167, 225);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            'Report',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 89,
              height: 28,
              child: ElevatedButton(
                  onPressed: () {
                    firstchangeColor();
                    //
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: firstButtonColor,
                  ),
                  child: const Text(
                    'Weekly',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 94,
              height: 28,
              child: ElevatedButton(
                  onPressed: () {
                    secondchangeColor();
                    //
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondButtonColor,
                  ),
                  child: const Text(
                    'Monthly',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  )),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 360,
              height: 550,
              child: FutureBuilder(
                future: handler.quaryOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data![index]['state'] == '결제완료') {
                          return Container(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: const Color(0xffE4E4E4),
                                      ),
                                      child: Center(
                                          child: Image.memory(
                                        snapshot.data![index]['image'],
                                        width: 100,
                                      )),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 5, 0),
                                          child: Text(
                                            snapshot.data![index]['brand'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index]['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(snapshot.data![index]['sname']),
                                    Text(
                                        '${snapshot.data![index]['total_price']}'),
                                    Text(
                                        '수량 : ${snapshot.data![index]['quantity']}'),
                                  ],
                                )
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('data 없음'),
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            //   child: Text(
            //     'Total : ${shoePrice[0]}',
            //     style: TextStyle(
            //       color: Color(0xffDCB21C),
            //       fontWeight: FontWeight.bold,
            //       fontSize: 30
            //     ),
            //     ),
            // )
          ],
        ),
      ),
    );
  }

  firstchangeColor() {
    firstButtonColor = const Color(0xff6644AB);
    secondButtonColor = const Color.fromARGB(255, 186, 167, 225);
    setState(() {});
  }

  secondchangeColor() {
    firstButtonColor = const Color.fromARGB(255, 186, 167, 225);
    secondButtonColor = const Color(0xff6644AB);
    setState(() {});
  }
}
