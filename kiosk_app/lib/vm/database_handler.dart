import 'package:flutter/foundation.dart';
import 'package:kiosk_app/model/customer.dart';
import 'package:kiosk_app/model/product.dart';
import 'package:kiosk_app/model/store.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initiallizeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'kiosk.db'), onCreate: (db, version) async {
      await db.execute("""
            create table customer (
            id text primary key,
            name text,
            phone text,
            password text,
            image blob
            );
          """);

      await db.execute("""
              create table product (
              id text primary key,
              name text,
              size integer,
              color text,
              stock integer,
              price integer,
              brand text,
              image blob
              );
            """);

      await db.execute("""
              create table store (
              id text primary key,
              name text,
              address text
              );
            """);

      await db.execute("""
              create table orders (
              id text primary key,
              customer_id text,
              product_id text,
              store_id text,
              date date,
              quantity integer,
              total_price integer,
              pickup_date date,
              FOREIGN KEY(customer_id) REFERENCES customer(id),
              FOREIGN KEY(product_id) REFERENCES product(id)
              FOREIGN KEY(store_id) REFERENCES store(id)
              );
            """);

      await db.execute("""
              create table inventory (
              id text primary key,
              store_id text,
              product_id text,
                quantity integer,
                receiving_date date,
                state text,
                FOREIGN KEY(store_id) REFERENCES store(id),
                FOREIGN KEY(product_id) REFERENCES product(id)
              );
            """);
    }, version: 1);
  }

  Future<int> insertstore(Store store) async {
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawInsert("""
        insert into store (id, name, address)
        values(?,?,?)
      """, [store.id, store.name, store.address]);
    return result;
  }

  Future<int> insertproduct(Product product) async {
    int result = 0;
    final Database db = await initiallizeDB();
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

  Future<List<Product>> queryproduct() async {
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> //
        queryResults = await db.rawQuery('select * from product');
    if (kDebugMode) {
      print('Query Results: $queryResults');
    }
    return queryResults.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> deletProduct(Product product) async {
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawDelete("""
        delete from product where id = ?  
      """, [product.id]);
    if (kDebugMode) {
      print("Update return Value : $result");
    }
    return result;
  }

  Future<int> insertcustomer(Customer customer) async {
    int result = 0;
    final Database db = await initiallizeDB();
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
    final Database db = await initiallizeDB();
    final List<Map<String, dynamic>> queryResults =
        await db.rawQuery('SELECT * FROM customer WHERE id = ?', [id]);

    return queryResults.map((e) => Customer.fromMap(e)).toList();
  }

  Future<List<Product>> queryProductByName(String searchQuery) async {
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery(
      'select * from product where name like ?',
      ['%$searchQuery%'], // 검색어가 포함된 제품을 찾기 위한 조건
    );
    return queryResults.map((e) => Product.fromMap(e)).toList();
  }

  Future<Customer?> fetchCustomerByIdAndPassword(
      String id, String password) async {
    final Database db = await initiallizeDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM customer WHERE id = ? AND password = ?',
      [id, password],
    );

    if (result.isNotEmpty) {
      return Customer.fromMap(result.first);
    }
    return null; // 고객 정보가 없으면 null 반환
  }
}
