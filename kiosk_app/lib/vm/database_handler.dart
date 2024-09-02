import 'package:kiosk_app/model/customer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/orders.dart';
import '../model/product.dart';
import '../model/store.dart';

class DatabaseHandler{
  Future<Database> initiallizeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'kiosk.db'),
      onCreate: (db, version) async{
        await db.execute(
          """
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
              brand text,
              image blob
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
              id integer primary key autoincrement,
              customer_id text,
              product_id text,
              store_id text,
              date date,
              quantity integer,
              total_price integer,
              pickup_date date,
              state text,
              FOREIGN KEY(customer_id) REFERENCES customer(id),
              FOREIGN KEY(product_id) REFERENCES product(id),
              FOREIGN KEY(store_id) REFERENCES store(id)
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
  Future<List<Product>> quaryProduct() async{
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> queryResult = 
          await db.rawQuery('select * from product');
          return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> insertproduct(Product product)async{
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawInsert(
      """
        insert into product (id, name, size, color, stock, price, brand, image)
        values(?,?,?,?,?,?,?,?)
      """, [product.id, product.name, product.size, product.color, product.stock, product.price, product.brand, product.image]
    );
    return result;
  }

  Future<int> insertCustomer(Customer customer)async{
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawInsert(
      """
        insert into customer (id, name, phone, password, image)
        values(?,?,?,?,?)
      """, [customer.id, customer.name, customer.phone, customer.password, customer.image]
    );
    return result;
  }
  Future<List<Product>> quaryProductsize(String name) async{
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> queryResult = 
          await db.rawQuery('select * from product where name = ? order by size', [name]);
          return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  // Future<List<Store>> quaryStore() async{
  //   final Database db = await initiallizeDB();
  //   final List<Map<String, Object?>> queryResult = 
  //         await db.rawQuery(
  //           """select max(p.id) id, p.name, p.image image, o.totalprice, p.price 
  //           from orders o, product.p 
  //           where o.product_id = p.id 
  //           group by id
  //           """
  //           );
  //         return queryResult.map((e) => Store.fromMap(e)).toList();
  // }
    Future<List<Store>> quaryStore() async{
    final Database db = await initiallizeDB();
    final List<Map<String, Object?>> queryResult = 
          await db.rawQuery('select * from store');
          return queryResult.map((e) => Store.fromMap(e)).toList();
  }
  Future<int> insertOrders(Orders orders)async{
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawInsert(
      """
        insert into orders (customer_id, product_id, store_id, date, quantity, total_price, pickup_date, state)
        values(?,?,?,date('now'),?,?,date('now', '+7 days'),?)
      """, [orders.customer_id, orders.product_id, orders.store_id, orders.quantity, orders.total_price, orders.state]
    );
    return result;
  }
      Future<List<Map<String, dynamic>>> quaryOrders() async{
    final Database db = await initiallizeDB();
    final List<Map<String, dynamic>> queryResult = 
          await db.rawQuery(
            """
              select orders.id id, product.image image, product.name name, product.brand, orders.total_price total_price, orders.quantity quantity, store.name sname, orders.state state, product.color color, product.size size, orders.date date
              from orders inner join product on orders.product_id = product.id inner join store on orders.store_id = store.id
            """
            );
          return queryResult;
  }

  Future<int> updateOrders(int id)async{
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawUpdate(
      """
        update orders set state = '결제완료' where id = ?
      """,
      [id]
    );
    return result;
  }

  Future<int> deleteOrders(int number)async{
    int result = 0;
    final Database db = await initiallizeDB();
    result = await db.rawDelete(
      """
        delete from orders where id = ?
      """, [number]
    );
    print("Update return value : $result");
    return result;
  }
}