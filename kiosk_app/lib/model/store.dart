class Store {
  String id;
  String name;
  String address;

  Store({required this.id, required this.name, required this.address});

  Store.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        address = res['address'];
// 승현+정영 합친 버전
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }
}
