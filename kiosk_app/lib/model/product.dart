import 'dart:typed_data';

<<<<<<< HEAD
class Product {
  String id;
  String name;
  int size;
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
        size = res['size'],
        color = res['color'],
        stock = res['stock'],
        price = res['price'],
        brand = res['brand'],
        image = res['image'];
}
=======
class Product{
  final String id;
  final String name;
  final int size;
  final String color;
  final int stock;
  final int price;
  final String brand;
  final Uint8List image;
  Product({
    required this.id,
    required this.name,
    required this.size,
    required this.color,
    required this.stock,
    required this.price,
    required this.brand,
    required this.image
  });

  Product.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  name = res['name'],
  size = res['size'],
  color = res['color'],
  stock = res['stock'],
  price = res['price'],
  brand = res['brand'],
  image = res['image'];
}
>>>>>>> 9a84076f74a771fb90b157fe682ecba5f38d65a4
