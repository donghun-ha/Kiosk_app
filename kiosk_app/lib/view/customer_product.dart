import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/model/global.dart';
import 'package:kiosk_app/model/orders.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerProduct extends StatefulWidget {
  const CustomerProduct({super.key});

  @override
  State<CustomerProduct> createState() => _CustomerProductState();
}

class _CustomerProductState extends State<CustomerProduct> {
  late DatabaseHandler handler;
  late List<String> shoeColor;
  late List<Color> colorLinelist;
  late List<Color> shoeLineColor;
  late List<Color> localLineColor;
  late int count;
  late String selectSize;
  late String selectLocalname;
  late int price;
  late String selectColor;
  late List<String> colorFinalList;
  late List<String> colorFinalList2;

  var value = Get.arguments ?? '__';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    selectColor = '';
    price = 0;
    selectSize = '';
    selectLocalname = '';
    colorLinelist = [];
    shoeLineColor = [];
    localLineColor = [];
    count = 1;
    colorFinalList = [];
    colorFinalList2 = [];
    addColor();
  }

  addColor() {
    for (int i = 0; i < 11; i++) {
      colorLinelist.add(Colors.white);
    }
    for (int i = 0; i < 5; i++) {
      shoeLineColor.add(Colors.white);
    }
    for (int i = 0; i < 5; i++) {
      localLineColor.add(Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: handler.quaryProduct(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                    width: 450,
                    height: 380,
                    color: const Color(0xffEBE8E8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.memory(
                            snapshot.data![value[0]].image,
                            width: 550,
                          )
                        ],
                      ),
                    )),
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 15, 8, 15),
                                        child: Text(
                                          snapshot.data![value[0]].name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                            height: 9,
                                          ),
                                          Text(
                                            snapshot.data![value[0]].brand,
                                            style: const TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (count == 1) {
                                          } else {
                                            count--;
                                            setState(() {});
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.black,
                                        )),
                                    Text(
                                      '$count',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          count++;
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.add_circle,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text(
                            '${snapshot.data![value[0]].price}',
                            style: const TextStyle(
                                color: Color(0xffDCB21C),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Text(
                              '색상 선택',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 390,
                          child: FutureBuilder(
                            future: handler.quaryProductColor(snapshot.data![value[0]].name),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                for(int i = 0; i < snapshot.data!.length; i++){
                                  colorFinalList.add(snapshot.data![i].color);
                                }
                                colorFinalList2 = colorFinalList.toSet().toList();
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: colorFinalList2.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          selectColor = snapshot.data![index].color;
                                          selectColorBox(
                                              index, snapshot.data!.length);
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: shoeLineColor[index],
                                                  width: 2.0)),
                                          child: Center(
                                            child:
                                                Text(colorFinalList2[index]),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Text(
                            '사이즈 선택',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 390,
                          child: FutureBuilder(
                            future: handler.quaryProductsize(snapshot.data![value[0]].name, selectColor), //////
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          selectBox(index, snapshot.data!.length);
                                          selectSize = snapshot.data![index].id;
                                          price = snapshot.data![index].price;
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: colorLinelist[index],
                                                  width: 2.0)),
                                          child: Center(
                                            child: Text(
                                                '${snapshot.data![index].size}'),
                                          ),
                                        ),
                                      ),
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
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Text(
                              '지점 선택',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 390,
                          child: FutureBuilder(
                            future: handler.quaryStore(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          selectLocalBox(
                                              index, snapshot.data!.length);
                                          selectLocalname =
                                              snapshot.data![index].id;
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: localLineColor[index],
                                                  width: 2.0)),
                                          child: Center(
                                            child:
                                                Text(snapshot.data![index].name),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: SizedBox(
                        width: 300,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () async {
                              Orders orders = Orders(
                                  customer_id: checkId,
                                  product_id: selectSize,
                                  store_id: selectLocalname,
                                  quantity: count,
                                  total_price: price * count,
                                  state: '결제전');
                              await handler.insertOrders(orders);
                              Get.back();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff6644AB),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
          }else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // ---Function---
  selectBox(index, list) {
    for (int i = 0; i < list; i++) {
      // 버튼을 누르면 먼저 모두 하얀으로 바꾸고 선택한것을 빨간색으로 바꾸면 중복선택이 안된다.
      colorLinelist[i] = Colors.white;
    }

    colorLinelist[index] = Colors.black;
    setState(() {});
  }

  selectColorBox(index, list) {
    for (int i = 0; i < list; i++) {
      // 버튼을 누르면 먼저 모두 하얀으로 바꾸고 선택한것을 빨간색으로 바꾸면 중복선택이 안된다.
      shoeLineColor[i] = Colors.white;
    }

    shoeLineColor[index] = Colors.black;
    setState(() {});
  }

  selectLocalBox(index, list) {
    for (int i = 0; i < list; i++) {
      // 버튼을 누르면 먼저 모두 하얀으로 바꾸고 선택한것을 빨간색으로 바꾸면 중복선택이 안된다.
      localLineColor[i] = Colors.white;
    }

    localLineColor[index] = Colors.black;
    setState(() {});
  }
} // End
