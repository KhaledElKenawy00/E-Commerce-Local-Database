import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Database file name
  static const String _databaseName = 'ecommerce.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableProducts = 'products';
  static const String tableCustomers = 'customers';
  static const String tableOrders = 'orders';
  static const String tableOrderDetails = 'order_details';
  static const String tablePayments = 'payments';
  static const String tableShipping = 'shipping';

  // Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    print("++++++++++++++++++++$path");
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the tables in the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price INTEGER NOT NULL,
        stock INTEGER NOT NULL,
        category TEXT,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCustomers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        address TEXT,
        phone TEXT,
        signedIn INTEGER NOT NULL DEFAULT 0  -- 0 = signed out, 1 = signed in
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableOrders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderDate TEXT NOT NULL,
        totalAmount INTEGER NOT NULL,
        status TEXT NOT NULL,
        customerId INTEGER NOT NULL,
        FOREIGN KEY (customerId) REFERENCES $tableCustomers (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableOrderDetails (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price INTEGER NOT NULL,
        FOREIGN KEY (orderId) REFERENCES $tableOrders (id),
        FOREIGN KEY (productId) REFERENCES $tableProducts (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableShipping (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        shippingAddress TEXT NOT NULL,
        shippingDate TEXT,
        deliveryDate TEXT,
        shippingStatus TEXT NOT NULL,
        FOREIGN KEY (orderId) REFERENCES $tableOrders (id)
      )
    ''');

    // Add any other tables as needed...
  }

  Future<void> signOutAllUsers() async {
    final db = await database;

    // Set signedIn = 0 for all users
    await db.update(
      tableCustomers,
      {'signedIn': 0},
    );
  }

  // Check if the user is signed in (0 = false, 1 = true)
  Future<bool> isUserSignedIn() async {
    final db = await database;
    final result = await db.query(
      tableCustomers,
      where: 'signedIn = ?',
      whereArgs: [1], // Check for signed-in status
    );
    return result.isNotEmpty;
  }

  // Update the user's sign-in status
  Future<void> updateSignInStatus(int userId, bool signedIn) async {
    final db = await database;
    await db.update(
      tableCustomers,
      {'signedIn': signedIn ? 1 : 0},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Insert a new record into any table
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  // Retrieve all records from a table
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Retrieve a record by ID
  Future<Map<String, dynamic>?> queryById(String table, int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> queryByOrderId(
      String table, int id, String type) async {
    final db = await database;
    final result = await db.query(table, where: '$type = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Update a record in a table
  Future<int> update(String table, Map<String, dynamic> values, int id) async {
    final db = await database;
    return await db.update(table, values, where: 'id = ?', whereArgs: [id]);
  }

  // Delete a record from a table
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Close the database
  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }

  Future<Map<String, dynamic>?> queryUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      tableCustomers, // Querying the customers table
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    // Return the first record if found, otherwise return null
    return result.isNotEmpty ? result.first : null;
  }
}
