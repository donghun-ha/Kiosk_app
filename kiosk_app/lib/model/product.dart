class Product {
  String id;
  String name;
  int size;
  String color;
  int stock;
  int price;
  String brand;

  Product(
      {required this.id,
      required this.name,
      required this.size,
      required this.color,
      required this.stock,
      required this.price,
      required this.brand});

  Product.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        size = res['size'],
        color = res['color'],
        stock = res['stock'],
        price = res['price'],
        brand = res['brand'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'color': color,
      'stock': stock,
      'price': price,
      'brand': brand,
    };
  }
}
