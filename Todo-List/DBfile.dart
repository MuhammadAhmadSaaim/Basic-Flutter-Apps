import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static Future<Database> db() async {
    return openDatabase('To_do_List1', version: 1,
        onCreate: (Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> createTables(Database database) async {
    await database.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        firstname TEXT,
        lastname TEXT,
        address TEXT,
        picture TEXT,
        password TEXT
      )
    ''');

    await database.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY,
        title TEXT,
        pid INTEGER,
        FOREIGN KEY (pid) REFERENCES users (id)
      )
    ''');

    await database.execute('''
    CREATE TABLE Product(
      Productcode INTEGER PRIMARY KEY,
      PName TEXT,
      PPrice REAL,
      PQuantity INTEGER,
      userId INTEGER,
      FOREIGN KEY (userId) REFERENCES users (id)
    )
''');

  }

  static Future<int> addUser(
      String email,
      String password,
      String firstname,
      String lastname,
      String address,
      String? imagePath,
      ) async {

    final Database db = await DatabaseHelper.db();

    final existingUsers = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUsers.isNotEmpty) {
      return -1;

    }
    print("Inside addingUser");
    final data = {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'picture': imagePath,
    };

    final id = await db.insert(
      'users',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }
////////////////////////////////////////////////////////////////////////////////////////////////////

  static Future<String> getEmail(int userId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['email'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['email'] as String;
    }

    return '-';
  }

  static Future<String> getFirstName(int userId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['firstname'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['firstname'] as String;
    }

    return '-';
  }

  static Future<String> getLastName(int userId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['lastname'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['lastname'] as String;
    }

    return '-';
  }

  static Future<String> getAddress(int userId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['address'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['address'] as String;
    }

    return '-';
  }

  static Future<String?> getImage(int userId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['picture'],
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['picture'] as String?;
    }

    return null;
  }

  static Future<void> setFirstName(int userId, String firstname) async {
    final Database db = await DatabaseHelper.db();
    await db.update(
      'users',
      {'firstname': firstname},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> setLastName(int userId, String lastname) async {
    final Database db = await DatabaseHelper.db();
    await db.update(
      'users',
      {'lastname': lastname},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> setAddress(int userId, String address) async {
    final Database db = await DatabaseHelper.db();
    await db.update(
      'users',
      {'address': address},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> setImage(int userId, String imagePath) async {
    final Database db = await DatabaseHelper.db();
    await db.update(
      'users',
      {'picture': imagePath},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  static Future<int> checkemail(
      String email,

      ) async {

    final Database db = await DatabaseHelper.db();

    final existingUsers = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUsers.isNotEmpty) {
      return -1;
    }
    return 0;
  }

  static Future<Map<String, dynamic>?> checkLogin(String email, String password) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['id', 'email', 'password'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final user = result.first;
      if (user['password'] == password) {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', user['id'] as int);

        return user;
      }
    }

    return null;
  }


  static Future<List<Map<String, dynamic>>> getTasks(int pid) async {
    final Database db = await DatabaseHelper.db();
    return await db.query('todo',
        where: 'pid = ?', whereArgs: [pid], orderBy: "id ASC");
  }

  static Future<int> addTask(String title, int pid) async {
    print("Inside  addtask");
    final Database db = await DatabaseHelper.db();
    final data = {
      'title': title,
      'pid': pid,
    };
    final id = await db.insert(
      'todo',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<int> updateTask(
      int id, String newTitle) async {
    final Database db = await DatabaseHelper.db();

    final result = await db.update(
      'todo',
      {
        'title': newTitle
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteTask(int id) async {
    final Database db = await DatabaseHelper.db();
    await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getProducts(int userId) async {
    final Database db = await DatabaseHelper.db();
    return await db.query('Product',
        where: 'userId = ?', whereArgs: [userId], orderBy: "Productcode ASC");
  }

  static Future<int> addProduct(
      String productName,
      double productPrice,
      int productQuantity,
      int userId,
      ) async {
    final Database db = await DatabaseHelper.db();
    final data = {
      'PName': productName,
      'PPrice': productPrice,
      'PQuantity': productQuantity,
      'userId': userId,
    };
    final id = await db.insert(
      'Product',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }


  static Future<int> updateProduct(
      int productCode,
      String newName,
      double newPrice,
      int newQuantity,
      ) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.update(
      'Product',
      {
        'PName': newName,
        'PPrice': newPrice,
        'PQuantity': newQuantity,
      },
      where: 'Productcode = ?',
      whereArgs: [productCode],
    );
    return result;
  }


  static Future<void> deleteProduct(int productCode) async {
    final Database db = await DatabaseHelper.db();
    await db.delete(
      'Product',
      where: 'Productcode = ?',
      whereArgs: [productCode],
    );
  }
}
