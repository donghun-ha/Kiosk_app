import 'dart:typed_data';

class Product {
  String id;
  String name;
  String size; // int에서 String으로 변경
  String color;
  int stock;
  int price;
  String brand;
  Uint8List image;

  Product(
      {required this.id,
      required this.name,
      required this.size,
      required this.color,
      required this.stock,
      required this.price,
      required this.brand,
      required this.image});

  Product.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        size = res['size'].toString(),
        color = res['color'],
        stock = res['stock'],
        price = res['price'],
        brand = res['brand'],
        image = res['image'] != null
            ? (res['image'] is Uint8List
                ? res['image']
                : Uint8List.fromList(res['image'].cast<int>()))
            : null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'color': color,
      'stock': stock,
      'price': price,
      'brand': brand,
      'image': image, // image 필드 추가
    };
  }
}
