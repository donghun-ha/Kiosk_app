import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_text_app/model/product.dart';
import 'package:sqlite_text_app/model/store.dart';

class DatabaseHandler{
  Future<Database> initiallizeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'kiosk.db'),
      onCreate: (db, version) async{
        await db.execute(
          """
            PRAGMA foreign_keys = ON;
            create table customer (
            id text primary key,
            name text,
            phone text,
            password text,
            image blob
            );
          """);

          await db.execute(
            """
              create table product (
              id text primary key,
              name text,
              size integer,
              color text,
              stock integer,
              price integer,
              brand text
              );
            """
          );

          await db.execute(
            """
              create table store (
              id text primary key,
              name text,
              address text
              );
            """
          );

          await db.execute(
            """
              create table orders (
              id text primary key,
              customer_id text,
              product_id text,
              date date,
              quantity integer,
              total_price integer,
              pickup_date date,
              FOREIGN KEY(customer_id) REFERENCES customer(id),
              FOREIGN KEY(product_id) REFERENCES product(id)
              );
            """
          );

          await db.execute(
            """
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
            """
          );
      },
      version: 1
    );
  }

  Future<int> insertstore(Store store)async{
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawInsert(
      """
        insert into store (id, name, address)
        values(?,?,?)
      """, [store.id, store.name, store.address]
    );
    return result;
  }

  Future<int> insertproduct(Product product)async{
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawInsert(
      """
        insert into product (id, name, size, color, stock, price, brand)
        values(?,?,?,?,?,?,?)
      """, [product.id, product.name, product.size, product.color, product.stock, product.price, product.brand]
    );
    return result;
  }
}