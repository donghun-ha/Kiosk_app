import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/model/store.dart';
import 'package:kiosk_app/test/testid.dart';
import 'package:kiosk_app/test/testinsert.dart';
import 'package:kiosk_app/view/customer_product.dart';
import 'package:kiosk_app/vm/database_handler.dart';

class CustomerMain extends StatefulWidget {
  const CustomerMain({super.key});

  @override
  State<CustomerMain> createState() => _CustomerMainState();
}

class _CustomerMainState extends State<CustomerMain> {
  late List<String> storeId;
  late List<String> storeName;
  late List<String> storeAddress;
  late List<String> list;
  late List<String> duplicationbrand;
  late List<String> duplicationname;
  late List<int> duplicationprice;
  late List<Uint8List> duplicationimage;
  late List<String> duplicationFinalbrand;
  late List<String> duplicationFinalname;
  late List<int> duplicationFinalprice;
  late List<Uint8List> duplicationFinalimage;
  late List<int> checkName;
  late DatabaseHandler handler;
  late Future<List<Product>> productsFuture;
  late int countNum;
  late List<String> shoeId;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler(); // 먼저 DatabaseHandler를 초기화
    productsFuture = Future.value([]); // Future의 초기값 설정
    _initializeDatabase(); // 그 다음에 데이터베이스 초기화
    countNum = 0;
    duplicationbrand = [];
    duplicationname = [];
    duplicationprice = [];
    duplicationimage = [];
    shoeId = [];
    checkName = [];

    duplicationFinalbrand = [];
    duplicationFinalname = [];
    duplicationFinalprice = [];
    duplicationFinalimage = [];

    list = ['1', '2', '3', '3', '3'];
    storeId = [
      'S001',
      'S002',
      'S003',
    ];
    storeName = ['강남점', '역삼점', '반포점'];
    storeAddress = [
      '서울시 강남구',
      '서울시 역삼동',
      '서울시 반포구',
    ];
  }

  void _initializeDatabase() async {
    await handler.initializeDB(); // 데이터베이스 초기화
    setState(() {
      productsFuture = handler.quaryProduct(); // Future 설정 후 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              for (int i = 0; i < storeId.length; i++) {
                Store store = Store(
                    id: storeId[i],
                    name: storeName[i],
                    address: storeAddress[i]);
                await handler.insertStore(store);
              }
              reloadData();
            },
            child: const Text('Local'),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => const Testid())!.then((value) => reloadData());
            },
            child: const Text('ID'),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => const Testinsert())!.then((value) => reloadData());
            },
            child: const Text('Test'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            // 검색 관련 UI
            Container(
              width: 310,
              height: 55,
              color: const Color.fromARGB(255, 219, 219, 219),
              child: const Row(
                children: [Icon(Icons.search), Text('Search')],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: const Text('Nike')),
                TextButton(onPressed: () {}, child: const Text('NewBalance')),
                TextButton(onPressed: () {}, child: const Text('ProSpecs')),
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Popular',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 360,
              height: 510,
              child: FutureBuilder<List<Product>>(
                future: productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    for(int i = 0; i < snapshot.data!.length; i++){
                      duplicationbrand.add(snapshot.data![i].brand);
                      duplicationname.add(snapshot.data![i].name);
                      duplicationprice.add(snapshot.data![i].price);
                      if(i == 0){
                        duplicationimage.add(snapshot.data![i].image);
                        checkName.add(i);
                      }else if(i >= 1){
                        if(snapshot.data![i].name != snapshot.data![i-1].name){
                          duplicationimage.add(snapshot.data![i].image);
                        checkName.add(i);
                      }
                      }
                      // duplicationimage.add(snapshot.data![i].image);
                      shoeId.add(snapshot.data![i].id);
                    }
                    // for(int i = 0; i < checkName.length; i++){
                    //   for(int num = 0; num < snapshot.data!.length; num++){
                    //     if(snapshot.data![checkName[i]].name == snapshot.data![num].name){

                    //     }
                    //   }
                    // }
                    duplicationFinalbrand = duplicationbrand.toSet().toList();
                    duplicationFinalname = duplicationname.toSet().toList();
                    duplicationFinalprice = duplicationprice.toSet().toList();
                    duplicationFinalimage = duplicationimage.toSet().toList();
                    return GridView.builder(
                      itemCount: duplicationFinalname.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            countNum = index;
                            print(snapshot.data![index].id);
                            print(duplicationFinalname);
                            print(duplicationFinalimage.length);
                            Get.to(() => const CustomerProduct(), arguments: [
                              countNum,
                              shoeId
                            ])!.then((value) => reloadData(),);
                          },
                          child: Card(
                            color: const Color(0xffEBE8E8),
                            child: Center(
                              child: Column(
                                children: [
                                  Image.memory(
                                    duplicationFinalimage[index],
                                    width: 150,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 5, 0),
                                        child: Text(
                                          duplicationFinalbrand[index],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Text(
                                        duplicationFinalname[index],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 5, 0),
                                        child: Text(
                                          'Price ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                      ),
                                      Text(
                                        '${duplicationFinalprice[index]} ₩',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Color(0xffDCB21C)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // —Function—
  void reloadData() {
    setState(() {productsFuture = handler.quaryProduct();});
  }
}
