class Orders{
  String? id;
  String customer_id;
  String product_id;
  String store_id;
  String? date;
  int quantity;
  int totalprice;
  String? pickupdate;

  Orders({
    this.id,
    required this.customer_id,
    required this.product_id,
    required this.store_id,
    this.date,
    required this.quantity,
    required this.totalprice,
    this.pickupdate
  });

    Orders.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  customer_id = res['customer_id'],
  product_id = res['product_id'],
  store_id = res['store_id'],
  date = res['date'],
  quantity = res['quantity'],
  totalprice = res['totalprice'],
  pickupdate = res['pickupdate'];
}