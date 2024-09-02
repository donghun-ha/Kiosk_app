import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/model/store.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:kiosk_app/model/customer.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'kiosk.db'),
      onCreate: (db, version) async {
        await db.execute("PRAGMA foreign_keys = ON;");
        await db.execute("""
          CREATE TABLE customer (
            id TEXT PRIMARY KEY,
            name TEXT,
            phone TEXT,
            password TEXT,
            image BLOB
          );
        """);
        await db.execute("""
          CREATE TABLE product (
            id TEXT PRIMARY KEY,
            name TEXT,
            size INTEGER,
            color TEXT,
            stock INTEGER,
            price INTEGER,
            brand TEXT
          );
        """);
        await db.execute("""
          CREATE TABLE store (
            id TEXT PRIMARY KEY,
            name TEXT,
            address TEXT
          );
        """);
        await db.execute("""
          CREATE TABLE orders (
            id TEXT PRIMARY KEY,
            customer_id TEXT,
            product_id TEXT,
            store_id TEXT,
            date DATE,
            quantity INTEGER,
            total_price INTEGER,
            pickup_date DATE,
            FOREIGN KEY(customer_id) REFERENCES customer(id),
            FOREIGN KEY(product_id) REFERENCES product(id),
            FOREIGN KEY(store_id) REFERENCES store(id)
          );
        """);
        await db.execute("""
          CREATE TABLE inventory (
            id TEXT PRIMARY KEY,
            store_id TEXT,
            product_id TEXT,
            quantity INTEGER,
            receiving_date DATE,
            state TEXT,
            FOREIGN KEY(store_id) REFERENCES store(id),
            FOREIGN KEY(product_id) REFERENCES product(id)
          );
        """);
      },
      version: 1,
    );
  }

  Future<int> insertStore(Store store) async {
    final Database db = await initializeDB();
    return await db.insert('store', store.toMap());
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await initializeDB();
    return await db.query('orders', orderBy: 'date DESC');
  }

  Future<int> insertProduct(Product product) async {
    final Database db = await initializeDB();
    return await db.insert('product', product.toMap());
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result =
        await db.query('customer', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('사용자를 찾을 수 없습니다.');
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String phone,
    Uint8List? image,
  }) async {
    final db = await initializeDB();
    final Map<String, dynamic> updateData = {
      'name': name,
      'phone': phone,
    };
    if (image != null) {
      String base64Image = base64Encode(image);
      updateData['image'] = base64Image;
    }
    await db.update(
      'customer',
      updateData,
      where: 'id = ?',
      whereArgs: [1], // 현재 로그인된 사용자의 ID를 사용해야 합니다.
    );
  }

  Future<bool> changePassword(
      {required String currentPassword, required String newPassword}) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'customer',
      where: 'id = ? AND password = ?',
      whereArgs: [1, currentPassword], // 현재 로그인된 사용자의 ID를 사용해야 합니다.
    );
    if (result.isNotEmpty) {
      await db.update(
        'customer',
        {'password': newPassword},
        where: 'id = ?',
        whereArgs: [1], // 현재 로그인된 사용자의 ID를 사용해야 합니다.
      );
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getProductsSummary() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT
        id,
        name,
        brand,
        SUM(p.stock) as total_stock,
        price as avg_price
      FROM product p
      GROUP BY p.name, p.brand
    ''');
    return result;
  }

  Future<Map<String, dynamic>> getProductDetails(String productName) async {
    try {
      final db = await initializeDB();
      final List<Map<String, dynamic>> results = await db.query(
        'product',
        where: 'id = ?',
        whereArgs: [productName],
      );
      if (results.isEmpty) {
        throw Exception('Product not found');
      }
      return results.first;
    } catch (e) {
      print('Error in getProductDetails: $e');
      throw Exception('Failed to load product details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProductItems(String productName) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'product',
      where: 'name = ?',
      whereArgs: [productName],
    );
    print('Product items for name $productName: $result');
    return result;
  }

  Future<String> getStoreName() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query('store', limit: 1);
    if (result.isNotEmpty) {
      return result.first['name'] as String;
    } else {
      return 'Unknown Store';
    }
  }

  Future<Uint8List?> getProductImage(String productId) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'product',
      columns: ['image'],
      where: 'id = ?',
      whereArgs: [productId],
    );
    if (result.isNotEmpty && result.first['image'] != null) {
      return result.first['image'] as Uint8List;
    }
    return null;
  }

  Future<int> getPickupRequestCount() async {
    final db = await initializeDB();
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM orders
      WHERE date(pickup_date) >= date('now', 'localtime')
    ''');
    print('Pickup request count: ${result.first['count']}'); // 디버깅용 출력
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTodayPickupCount() async {
    final db = await initializeDB();
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM orders
      WHERE date(pickup_date) = date('now', 'localtime')
    ''');
    print('Today pickup count: ${result.first['count']}'); // 디버깅용 출력
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await initializeDB();
    return await db.query('product');
  }

  Future<void> printAllOrders() async {
    final db = await initializeDB();
    final orders = await db.query('orders');
    print('All orders:');
    for (var order in orders) {
      print(
          'ID: ${order['id']}, Date: ${order['date']}, Pickup Date: ${order['pickup_date']}');
    }
  }

  Future<void> checkDates() async {
    final db = await initializeDB();
    final now = DateTime.now();
    print('Current date: ${now.toIso8601String()}');
    final todayOrders = await db.rawQuery('''
      SELECT * FROM orders
      WHERE date(pickup_date) = date('now', 'localtime')
    ''');
    print('Today\'s pickup orders:');
    for (var order in todayOrders) {
      print(
          'ID: ${order['id']}, Date: ${order['date']}, Pickup Date: ${order['pickup_date']}');
    }
    final futureOrders = await db.rawQuery('''
      SELECT * FROM orders
      WHERE date(pickup_date) > date('now', 'localtime')
    ''');
    print('Future pickup orders:');
    for (var order in futureOrders) {
      print(
          'ID: ${order['id']}, Date: ${order['date']}, Pickup Date: ${order['pickup_date']}');
    }
  }

  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('주문을 찾을 수 없습니다.');
    }
  }

  Future<Customer?> fetchCustomerByIdAndPassword(
      String id, String password) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM customer WHERE id = ? AND password = ?',
      [id, password],
    );

    if (result.isNotEmpty) {
      return Customer.fromMap(result.first);
    }
    return null; // 고객 정보가 없으면 null 반환
  }

  Future<int> insertcustomer(Customer customer) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert("""
        insert into customer (id, name, phone, password, image)
        values(?,?,?,?,?)
      """, [
      customer.id,
      customer.name,
      customer.phone,
      customer.password,
      customer.image
    ]);
    return result;
  }

  Future<List<Customer>> queryCustomersById(String id) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResults =
        await db.rawQuery('SELECT * FROM customer WHERE id = ?', [id]);

    return queryResults.map((e) => Customer.fromMap(e)).toList();
  }
}
