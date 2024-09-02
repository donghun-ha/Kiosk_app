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
    return await db.rawInsert("""
        INSERT INTO store (id, name, address)
        VALUES (?, ?, ?)
      """, [store.id, store.name, store.address]);
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

  Future<List<Product>> queryProductByName(String name) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('SELECT * FROM product WHERE name = ? ORDER BY size', [name]);
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

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
        VALUES (?, ?, ?, date('now'), ?, ?, date('now', '+7 days'), ?)
      """, [
      order.customer_id,
      order.product_id,
      order.store_id,
      order.quantity,
      order.total_price,
      order.state
    ]);
  }

  Future<List<Map<String, dynamic>>> queryOrders() async {
    final Database db = await initializeDB();
    return await db.rawQuery("""
        SELECT orders.id, product.image, product.name, product.brand, orders.total_price, orders.quantity, store.name AS sname, orders.state, product.color, product.size, orders.date
        FROM orders
        INNER JOIN product ON orders.product_id = product.id
        INNER JOIN store ON orders.store_id = store.id
      """);
  }

  Future<int> updateOrderState(int id) async {
    final Database db = await initializeDB();
    return await db.rawUpdate("""
        UPDATE orders SET state = '결제완료' WHERE id = ?
      """, [id]);
  }

  Future<int> deleteOrder(int id) async {
    final Database db = await initializeDB();
    return await db.rawDelete("""
        DELETE FROM orders WHERE id = ?
      """, [id]);
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

  Future<List<Customer>> queryCustomersById(String id) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResults =
        await db.rawQuery('SELECT * FROM customer WHERE id = ?', [id]);

    return queryResults.map((e) => Customer.fromMap(e)).toList();
  }

  Future<int> insertproduct(Product product) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert("""
        insert into product (id, name, size, color, stock, price, brand,image)
        values(?,?,?,?,?,?,?,?)
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
    return result;
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

  Future<List<Product>> quaryProduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from product');
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Customer>> queryCustomersId(Customer customer) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResults =
        await db.rawQuery('SELECT * FROM customer WHERE id = ?', [customer.id]);

    return queryResults.map((e) => Customer.fromMap(e)).toList();
  }
}
