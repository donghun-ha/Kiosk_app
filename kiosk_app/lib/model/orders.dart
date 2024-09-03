class Orders {
  int? id;
  String customer_id;
  String product_id;
  String store_id;
  DateTime? date; // DateTime 타입
  int quantity;
  int total_price;
  DateTime? pickup_date; // DateTime 타입
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

  // Map을 Orders 객체로 변환하는 fromMap 메서드
  Orders.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        customer_id = res['customer_id'],
        product_id = res['product_id'],
        store_id = res['store_id'],
        date = res['date'] != null
            ? DateTime.parse(res['date'])
            : null, // 문자열을 DateTime으로 변환
        quantity = res['quantity'],
        total_price = res['total_price'],
        pickup_date = res['pickup_date'] != null
            ? DateTime.parse(res['pickup_date'])
            : null, // 문자열을 DateTime으로 변환
        state = res['state'];

  // Orders 객체를 Map으로 변환하는 toMap 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customer_id,
      'product_id': product_id,
      'store_id': store_id,
      'date': date?.toIso8601String(), // DateTime을 문자열로 변환
      'quantity': quantity,
      'total_price': total_price,
      'pickup_date': pickup_date?.toIso8601String(), // DateTime을 문자열로 변환
      'state': state,
    };
  }
}
