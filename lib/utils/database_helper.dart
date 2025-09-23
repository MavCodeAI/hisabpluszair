import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/customer.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'vyapar_clone.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create invoices table
    await db.execute('''
      CREATE TABLE invoices(
        id TEXT PRIMARY KEY,
        invoiceNumber TEXT NOT NULL,
        customerName TEXT NOT NULL,
        customerPhone TEXT NOT NULL,
        customerEmail TEXT,
        date TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        subtotal REAL NOT NULL,
        gstRate REAL NOT NULL,
        gstAmount REAL NOT NULL,
        total REAL NOT NULL,
        status TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // Create invoice_items table
    await db.execute('''
      CREATE TABLE invoice_items(
        id TEXT PRIMARY KEY,
        invoiceId TEXT NOT NULL,
        productName TEXT NOT NULL,
        description TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        rate REAL NOT NULL,
        amount REAL NOT NULL,
        FOREIGN KEY (invoiceId) REFERENCES invoices (id)
      )
    ''');

    // Create products table
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        stockQuantity INTEGER NOT NULL,
        minStockLevel INTEGER NOT NULL,
        unit TEXT NOT NULL,
        barcode TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create expenses table
    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        receiptPath TEXT,
        isGstApplicable INTEGER NOT NULL,
        gstAmount REAL NOT NULL
      )
    ''');

    // Create customers table
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        address TEXT,
        gstNumber TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        totalPurchases REAL DEFAULT 0.0,
        pendingAmount REAL DEFAULT 0.0,
        customerType TEXT DEFAULT 'Regular',
        notes TEXT
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    // Sample customers
    await db.insert('customers', {
      'name': 'John Doe',
      'phone': '+92 300 1234567',
      'email': 'john.doe@email.com',
      'address': 'House 123, Street 45, Karachi',
      'gstNumber': '27AAAAA0000A1Z5',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'totalPurchases': 54516.0,
      'pendingAmount': 15000.0,
      'customerType': 'Premium',
      'notes': 'Regular customer, preferred payment terms',
    });

    await db.insert('customers', {
      'name': 'Sarah Khan',
      'phone': '+92 321 9876543',
      'email': 'sarah.khan@business.com',
      'address': 'Office 45, Plaza 12, Lahore',
      'gstNumber': '27BBBBB1111B2Z6',
      'createdAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'totalPurchases': 125000.0,
      'pendingAmount': 0.0,
      'customerType': 'VIP',
      'notes': 'VIP customer, bulk orders',
    });

    await db.insert('customers', {
      'name': 'Ahmed Ali',
      'phone': '+92 333 5555666',
      'email': null,
      'address': 'Shop 78, Market Road, Islamabad',
      'gstNumber': null,
      'createdAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'totalPurchases': 8500.0,
      'pendingAmount': 2500.0,
      'customerType': 'Regular',
      'notes': 'Cash payments only',
    });

    // Sample products
    await db.insert('products', {
      'id': 'prod_001',
      'name': 'Laptop HP Pavilion',
      'description': 'HP Pavilion 15-inch laptop with Intel i5 processor',
      'category': 'Electronics',
      'price': 45000.0,
      'stockQuantity': 10,
      'minStockLevel': 3,
      'unit': 'pcs',
      'barcode': null,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('products', {
      'id': 'prod_002',
      'name': 'Office Chair',
      'description': 'Ergonomic office chair with lumbar support',
      'category': 'Furniture',
      'price': 8500.0,
      'stockQuantity': 25,
      'minStockLevel': 5,
      'unit': 'pcs',
      'barcode': null,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('products', {
      'id': 'prod_003',
      'name': 'Wireless Mouse',
      'description': 'Logitech wireless optical mouse',
      'category': 'Electronics',
      'price': 1200.0,
      'stockQuantity': 50,
      'minStockLevel': 10,
      'unit': 'pcs',
      'barcode': null,
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Sample expenses
    await db.insert('expenses', {
      'id': 'exp_001',
      'title': 'Office Rent',
      'description': 'Monthly office rent payment',
      'amount': 25000.0,
      'category': 'Rent',
      'date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'paymentMethod': 'bank_transfer',
      'receiptPath': null,
      'isGstApplicable': 1,
      'gstAmount': 4500.0,
    });

    await db.insert('expenses', {
      'id': 'exp_002',
      'title': 'Office Supplies',
      'description': 'Stationery and office materials',
      'amount': 3500.0,
      'category': 'Office Supplies',
      'date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'paymentMethod': 'cash',
      'receiptPath': null,
      'isGstApplicable': 1,
      'gstAmount': 630.0,
    });

    // Sample invoice
    const invoiceId = 'inv_001';
    await db.insert('invoices', {
      'id': invoiceId,
      'invoiceNumber': 'INV25001',
      'customerName': 'John Doe',
      'customerPhone': '+92 300 1234567',
      'customerEmail': 'john.doe@email.com',
      'date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'dueDate': DateTime.now().add(const Duration(days: 28)).toIso8601String(),
      'subtotal': 46200.0,
      'gstRate': 18.0,
      'gstAmount': 8316.0,
      'total': 54516.0,
      'status': 'pending',
      'notes': 'Payment due in 30 days',
    });

    // Sample invoice items
    await db.insert('invoice_items', {
      'id': 'item_001',
      'invoiceId': invoiceId,
      'productName': 'Laptop HP Pavilion',
      'description': 'HP Pavilion 15-inch laptop',
      'quantity': 1,
      'rate': 45000.0,
      'amount': 45000.0,
    });

    await db.insert('invoice_items', {
      'id': 'item_002',
      'invoiceId': invoiceId,
      'productName': 'Wireless Mouse',
      'description': 'Logitech wireless mouse',
      'quantity': 1,
      'rate': 1200.0,
      'amount': 1200.0,
    });
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Customer CRUD operations
  Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    return await db.insert('customers', customer.toMap());
  }

  Future<List<Customer>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }

  Future<Customer?> getCustomer(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }
}
