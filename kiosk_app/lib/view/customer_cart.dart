import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class CustomerCart extends StatefulWidget {
  const CustomerCart({super.key});

  @override
  State<CustomerCart> createState() => _CustomerCartState();
}

class _CustomerCartState extends State<CustomerCart> {
  late DatabaseHandler handler;
  late List<String> shoeName;
  late List<String>shoePrice;
  late List<String>shoeImage;
  late int count;
  late List<String> localName;
  late String dropdownValue;
  late String nameValue;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    shoeName = ['나이키 에어'];
    shoePrice = ['100000'];
    shoeImage = ['사진'];
    count = 1;
    nameValue = ''; ///////////
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Item in cart',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30
          ),
          ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 360,
              height: 500,
              child: FutureBuilder(
                future: handler.quaryOrdercart(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Image.memory(
                                snapshot.data!['image']
                              ),
                              ),
                              decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xffE4E4E4),
                                      ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 10, 0),
                            child: Column(
                              children: [
                                Text('${shoeName[index]}'),
                                Text('${shoePrice[index]}'),
                                Text('수량 : $count'), 
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  );
                  }else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
              child: SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    //
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6644AB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                    )
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}