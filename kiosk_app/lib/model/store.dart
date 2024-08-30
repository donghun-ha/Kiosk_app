class Store {
  String id;
  String name;
  String address;

  Store({required this.id, required this.name, required this.address});

  Store.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        address = res['address'];
}
