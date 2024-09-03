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

  Orders(
      {this.id,
      required this.customer_id,
      required this.product_id,
      required this.store_id,
      this.date,
      required this.quantity,
      required this.total_price,
      this.pickup_date,
      required this.state});

  Orders.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        customer_id = res['customer_id'],
        product_id = res['product_id'],
        store_id = res['store_id'],
        date = res['date'],
        quantity = res['quantity'],
        total_price = res['total_price'],
        pickup_date = res['pickup_date'],
        state = res['state'];
}
