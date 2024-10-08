import 'dart:typed_data';

class Customer {
  final String id;
  final String name;
  final String phone;
  final String password;
  final Uint8List? image;

  Customer(
      {required this.id,
      required this.name,
      required this.phone,
      required this.password,
      this.image});

  Customer.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        phone = res['phone'],
        password = res['password'],
        image = res['image'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'image': image,
    };
  }
}
