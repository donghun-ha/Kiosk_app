import 'dart:typed_data';

class Customer {
  String id;
  String name;
  String phone;
  String password;
  Uint8List? image;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
    this.image,
  });

  Customer.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        phone = res['phone'],
        password = res['password'],
        image = res['image'];
}
