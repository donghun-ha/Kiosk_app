import 'package:flutter/material.dart';
import 'package:sqlite_text_app/model/product.dart';
import 'package:sqlite_text_app/model/store.dart';
import 'package:sqlite_text_app/vm/database_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHandler handler = DatabaseHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqltest'),
        actions: [
          IconButton(
            onPressed: () async{
              Store store = Store(
                id: 'S001',
                name: '홍길동',
                address: '서울시 강남구'
                );
                Product product = Product(
                  id: 'P001', 
                  name: '신발', 
                  size: 250, 
                  color: 'white', 
                  stock: 10, 
                  price: 50000, 
                  brand: 'adidas'
                  );
                await handler.insertstore(store);
                await handler.insertproduct(product);
                setState(() {});
            },
            icon: const Icon(Icons.add_outlined))
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('빈 화면')
          ],
        ),
      ),
    );
  }
}