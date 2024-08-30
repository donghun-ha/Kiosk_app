import 'package:flutter/material.dart';
import 'package:kiosk_app/vm/database_handler.dart';
import 'dart:typed_data';

class LocalInventDetailPage extends StatelessWidget {
  final String productName;
  final DatabaseHandler _databaseHandler = DatabaseHandler();

  LocalInventDetailPage({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0FFF5),
        title: Text('상품 재고 상세'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/local_profile');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _databaseHandler.getProductItems(productName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}\n'
                'Stack trace: ${snapshot.stackTrace}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available for this product'));
          }

          final items = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  productName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder<Uint8List?>(
                future: _databaseHandler
                    .getProductImage(items.first['id'].toString()),
                builder: (context, imageSnapshot) {
                  if (imageSnapshot.connectionState == ConnectionState.done &&
                      imageSnapshot.data != null) {
                    return Image.memory(
                      imageSnapshot.data!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Icon(Icons.image_not_supported, size: 200);
                  }
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('${item['color']} - ${item['size']}'),
                        subtitle: Text('품목 ID: ${item['id']}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('재고: ${item['stock']}'),
                            Text('가격: ${_formatPrice(item['price'])}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    if (price is num) {
      return '${price.toStringAsFixed(2)}원';
    }
    if (price is String) {
      try {
        return '${double.parse(price).toStringAsFixed(2)}원';
      } catch (e) {
        return '${price}원';
      }
    }
    return '${price}원';
  }
}
