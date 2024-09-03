class Orders {
  int? id;
  String customer_id;
  String product_id;
  String store_id;
  String? date;
  int quantity;
  int total_price;
  String? pickup_date;
  String state;

  Orders({
    this.id,
    required this.customer_id,
    required this.product_id,
    required this.store_id,
    this.date,
    required this.quantity,
    required this.total_price,
    this.pickup_date,
    required this.state,
  });

  Orders.fromMap(Map<String, dynamic> res)
      : id = res['id'] is int ? res['id'] : int.tryParse(res['id'].toString()),
        customer_id = res['customer_id'] ?? '',
        product_id = res['product_id'] ?? '',
        store_id = res['store_id'] ?? '',
        date = res['date'] ?? '',
        quantity = res['quantity'] is int
            ? res['quantity']
            : int.tryParse(res['quantity'].toString()) ?? 0,
        total_price = res['total_price'] is int
            ? res['total_price']
            : int.tryParse(res['total_price'].toString()) ?? 0,
        pickup_date = res['pickup_date'] ?? '',
        state = res['state'] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customer_id,
      'product_id': product_id,
      'store_id': store_id,
      'date': date,
      'quantity': quantity,
      'total_price': total_price,
      'pickup_date': pickup_date,
      'state': state,
    };
  }
}
