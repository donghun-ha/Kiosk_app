import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/orders.dart';
import '../model/product.dart';
import '../model/store.dart';
import '../model/customer.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'kiosk.db'),
      onCreate: (db, version) async {
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
              size TEXT,
              color TEXT,
              stock INTEGER,
              price INTEGER,
              brand TEXT,
              image BLOB
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
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              customer_id TEXT,
              product_id TEXT,
              store_id TEXT,
              date DATE,
              quantity INTEGER,
              total_price INTEGER,
              pickup_date DATE,
              state TEXT,
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

    // ----승현 형님 insertStore----
    return await db.insert('store', store.toMap());
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await initializeDB();
    return await db.query('orders', orderBy: 'date DESC');
    // --------------------------
    // return await db.rawInsert("""
    //     INSERT INTO store (id, name, address)
    //     VALUES (?, ?, ?)
    //   """, [store.id, store.name, store.address]);
  }

  Future<List<Product>> queryProduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM product');
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> insertProduct(Product product) async {
    final Database db = await initializeDB();
    return await db.rawInsert("""
        INSERT INTO product (id, name, size, color, stock, price, brand, image)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      """, [
      product.id,
      product.name,
      product.size,
      product.color,
      product.stock,
      product.price,
      product.brand,
      product.image
    ]);
  }

  Future<int> insertCustomer(Customer customer) async {
    final Database db = await initializeDB();
    return await db.rawInsert("""
        INSERT INTO customer (id, name, phone, password, image)
        VALUES (?, ?, ?, ?, ?)
      """, [
      customer.id,
      customer.name,
      customer.phone,
      customer.password,
      customer.image
    ]);
  }

  // Future<List<Product>> queryProductByName(String name) async {
  //   final Database db = await initializeDB();
  //   final List<Map<String, Object?>> queryResult = await db
  //       .rawQuery('SELECT * FROM product WHERE name = ? ORDER BY size', [name]);
  //   return queryResult.map((e) => Product.fromMap(e)).toList();
  // }

  Future<List<Store>> queryStore() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM store');
    return queryResult.map((e) => Store.fromMap(e)).toList();
  }

  Future<int> insertOrder(Orders order) async {
    final Database db = await initializeDB();
    return await db.rawInsert("""
        INSERT INTO orders (customer_id, product_id, store_id, date, quantity, total_price, pickup_date, state)
        VALUES (?, ?, ?, date('now'), ?, ?, date('now', '+7 days'), ?, ?)
      """, [
      order.customer_id,
      order.product_id,
      order.store_id,
      order.date,
      order.quantity,
      order.total_price,
      order.pickup_date,
      order.state
    ]);
  }

  Future<List<Map<String, dynamic>>> queryOrders() async {
    final Database db = await initializeDB();
    return await db.rawQuery("""
        SELECT orders.id, product.image, product.name, product.brand, orders.total_price, orders.quantity, store.name AS sname, orders.state, product.color, product.size, orders.date, orders.customer_id
        FROM orders
        INNER JOIN product ON orders.product_id = product.id
        INNER JOIN store ON orders.store_id = store.id
      """);
  }

  Future<int> updateOrderState(int orderId, String newState) async {
    final Database db = await initializeDB(); // 데이터베이스 초기화
    int result = await db.update(
      'orders', // 업데이트할 테이블 이름
      {'state': newState}, // 업데이트할 데이터
      where: 'id = ?', // 조건
      whereArgs: [orderId], // 조건 값
    );
    return result; // 업데이트된 행의 개수를 반환
  }

  Future<int> deleteOrder(int id) async {
    final Database db = await initializeDB();
    return await db.rawDelete("""
        DELETE FROM orders WHERE id = ?
      """, [id]);
  }

  Future<List<Customer>> queryCustomersById(String id) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResults =
        await db.rawQuery('SELECT * FROM customer WHERE id = ?', [id]);

    return queryResults.map((e) => Customer.fromMap(e)).toList();
  }

  // ---- 승현+정영 ----
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

  Future<List<Product>> queryProductByName(String searchQuery) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
      'select * from product where name like ?',
      ['%$searchQuery%'], // 검색어가 포함된 제품을 찾기 위한 조건
    );
    return queryResults.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> deletProduct(Product product) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawDelete("""
        delete from product where id = ?  
      """, [product.id]);
    if (kDebugMode) {
      Future<int> deletProduct(Product product) async {
        int result = 0;
        final Database db = await initializeDB();
        result = await db.rawDelete("""
        delete from product where id = ?  
      """, [product.id]);
        if (kDebugMode) {
          print("Update return Value : $result");
        }
        return result;
      }

      print("Update return Value : $result");
    }
    return result;
  }

  Future<List<Product>> quaryProductsize(String name) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('select * from product where name = ? order by size', [name]);
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Store>> quaryStore() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from store');
    return queryResult.map((e) => Store.fromMap(e)).toList();
  }

  Future<int> insertOrders(Orders orders) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert("""
        insert into orders (customer_id, product_id, store_id, date, quantity, total_price, pickup_date, state)
        values(?,?,?,date('now'),?,?,date('now', '+7 days'),?)
      """, [
      orders.customer_id,
      orders.product_id,
      orders.store_id,
      orders.quantity,
      orders.total_price,
      orders.state
    ]);
    return result;
  }

// ---- 정영+승현 -----
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

  Future<List<Product>> queryproduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults =
        await db.rawQuery('select * from product');
    if (kDebugMode) {
      print('Query Results: $queryResults');
    }
    return queryResults.map((e) => Product.fromMap(e)).toList();
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

  Future<Map<String, dynamic>> getOrderById(int orderId) async {
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

// -------------------------------
  Future<List<Map<String, dynamic>>> quaryOrders() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery("""
              select orders.id id, product.image image, product.name name, product.brand, orders.total_price total_price, orders.quantity quantity, store.name sname, orders.state state, product.color color, product.size size, orders.date date
              from orders inner join product on orders.product_id = product.id inner join store on orders.store_id = store.id
            """);
    return queryResult;
  }

  Future<int> updateOrders(int id) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate("""
        update orders set state = '결제완료' where id = ?
      """, [id]);
    return result;
  }

  // Future<List<Product>> quaryProduct() async {
  //   final Database db = await initializeDB();
  //   final List<Map<String, Object?>> queryResult =
  //       await db.rawQuery('select * from product');
  //   return queryResult.map((e) => Product.fromMap(e)).toList();
  // }

  Future<List<Product>> quaryProduct() async {
    final Database db = await initializeDB();
    var result = await db.rawQuery('SELECT * FROM product');
    print(result); // 데이터베이스 쿼리 결과 확인
    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Customer>> queryCustomersId(Customer customer) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResults =
        await db.rawQuery('SELECT * FROM customer WHERE id = ?', [customer.id]);
    return queryResults.map((e) => Customer.fromMap(e)).toList();
  }

  // 키오스크
  Future<List<Map<String, dynamic>>> queryOrderProducts(
      String orderNumber) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('''
    SELECT p.id, p.name, p.brand, p.color, p.size, p.price, p.stock, p.image, o.quantity
    FROM orders o
    INNER JOIN product p ON o.product_id = p.id
    WHERE o.id = ?
  ''', [orderNumber]);

    return queryResult;
  }

  Future<List<Map<String, dynamic>>> queryProductById(String productId) async {
    final Database db = await initializeDB(); // 데이터베이스 초기화
    final List<Map<String, dynamic>> result = await db.query(
      'product', // 제품 테이블
      where: 'id = ?', // 특정 제품 ID에 대해 조회
      whereArgs: [productId],
    );
    return result;
  }

  Future<int> getPendingOrdersCount() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'state = ?',
      whereArgs: ['출고 완료'],
    );
    return maps.length;
  }

  Future<int> getDailySales(String state, DateTime date) async {
    final Database db = await initializeDB();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'state = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        state,
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String()
      ],
    );

    int totalSales = 380000;
    for (var row in maps) {
      totalSales += row['total_price'] as int;
    }

    return totalSales;
  }
} // End 