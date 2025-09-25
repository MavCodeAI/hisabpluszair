import 'dart:async';
import 'package:flutter/foundation.dart';
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
      version: 2, // Updated version to include new tables
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        gstRate REAL NOT NULL, -- Sales Tax rate (Pakistan)
        gstAmount REAL NOT NULL, -- Sales Tax amount (Pakistan)
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

    // Create new tables for enhanced inventory
    await _createNewTables(db);

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new tables for enhanced inventory features
      await _createNewTables(db);
      await _insertSampleInventoryData(db);
    }
  }

  Future<void> _createNewTables(Database db) async {
    // Create suppliers table
    await db.execute('''
      CREATE TABLE suppliers(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        contactPerson TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT NOT NULL,
        ntnNumber TEXT,
        paymentTerms TEXT NOT NULL,
        creditLimit REAL DEFAULT 0.0,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        totalPurchases REAL DEFAULT 0.0,
        pendingAmount REAL DEFAULT 0.0
      )
    ''');

    // Create stock_movements table
    await db.execute('''
      CREATE TABLE stock_movements(
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        previousStock INTEGER NOT NULL,
        newStock INTEGER NOT NULL,
        unitCost REAL NOT NULL,
        totalValue REAL NOT NULL,
        reason TEXT NOT NULL,
        referenceId TEXT,
        supplierId TEXT,
        performedBy TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (productId) REFERENCES products (id),
        FOREIGN KEY (supplierId) REFERENCES suppliers (id)
      )
    ''');

    // Create purchase_orders table
    await db.execute('''
      CREATE TABLE purchase_orders(
        id TEXT PRIMARY KEY,
        orderNumber TEXT NOT NULL,
        supplierId TEXT NOT NULL,
        supplierName TEXT NOT NULL,
        orderDate TEXT NOT NULL,
        expectedDate TEXT,
        receivedDate TEXT,
        subtotal REAL NOT NULL,
        salesTaxRate REAL NOT NULL,
        salesTaxAmount REAL NOT NULL,
        total REAL NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (supplierId) REFERENCES suppliers (id)
      )
    ''');

    // Create purchase_order_items table
    await db.execute('''
      CREATE TABLE purchase_order_items(
        id TEXT PRIMARY KEY,
        purchaseOrderId TEXT NOT NULL,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        description TEXT NOT NULL,
        orderedQuantity INTEGER NOT NULL,
        receivedQuantity INTEGER DEFAULT 0,
        unitPrice REAL NOT NULL,
        totalPrice REAL NOT NULL,
        unit TEXT NOT NULL,
        FOREIGN KEY (purchaseOrderId) REFERENCES purchase_orders (id),
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');

    // Create goods_received_notes table
    await db.execute('''
      CREATE TABLE goods_received_notes(
        id TEXT PRIMARY KEY,
        grnNumber TEXT NOT NULL,
        purchaseOrderId TEXT NOT NULL,
        purchaseOrderNumber TEXT NOT NULL,
        supplierId TEXT NOT NULL,
        supplierName TEXT NOT NULL,
        receivedDate TEXT NOT NULL,
        receivedBy TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (purchaseOrderId) REFERENCES purchase_orders (id),
        FOREIGN KEY (supplierId) REFERENCES suppliers (id)
      )
    ''');

    // Create goods_received_items table
    await db.execute('''
      CREATE TABLE goods_received_items(
        id TEXT PRIMARY KEY,
        grnId TEXT NOT NULL,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        orderedQuantity INTEGER NOT NULL,
        receivedQuantity INTEGER NOT NULL,
        rejectedQuantity INTEGER DEFAULT 0,
        unitPrice REAL NOT NULL,
        totalValue REAL NOT NULL,
        unit TEXT NOT NULL,
        condition TEXT DEFAULT 'good',
        notes TEXT,
        FOREIGN KEY (grnId) REFERENCES goods_received_notes (id),
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');

    // Add costPrice column to products table if it doesn't exist
    try {
      await db.execute('''
        ALTER TABLE products ADD COLUMN costPrice REAL DEFAULT 0.0
      ''');
    } catch (e) {
      // Column already exists, ignore error
      if (kDebugMode) {
        print('costPrice column already exists: $e');
      }
    }

    // Add supplierId column to products table if it doesn't exist
    try {
      await db.execute('''
        ALTER TABLE products ADD COLUMN supplierId TEXT
      ''');
    } catch (e) {
      // Column already exists, ignore error
      if (kDebugMode) {
        print('supplierId column already exists: $e');
      }
    }
  }

  Future<void> _insertSampleData(Database db) async {
    // Sample customers
    await db.insert('customers', {
      'name': 'John Doe',
      'phone': '+92 300 1234567',
      'email': 'john.doe@email.com',
      'address': 'House 123, Street 45, Karachi',
      'gstNumber': '12345678', // NTN Number (Pakistan)
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'totalPurchases': 54054.0, -- Updated to match Pakistani Sales Tax calculation
      'pendingAmount': 15000.0,
      'customerType': 'Premium',
      'notes': 'Regular customer, preferred payment terms',
    });

    await db.insert('customers', {
      'name': 'Sarah Khan',
      'phone': '+92 321 9876543',
      'email': 'sarah.khan@business.com',
      'address': 'Office 45, Plaza 12, Lahore',
      'gstNumber': '87654321', // NTN Number (Pakistan)
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
      'costPrice': 40000.0, // Added cost price
      'stockQuantity': 10,
      'minStockLevel': 3,
      'unit': 'pcs',
      'barcode': null,
      'supplierId': 'sup_001', // Added supplier reference
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('products', {
      'id': 'prod_002',
      'name': 'Office Chair',
      'description': 'Ergonomic office chair with lumbar support',
      'category': 'Furniture',
      'price': 8500.0,
      'costPrice': 7000.0, // Added cost price
      'stockQuantity': 25,
      'minStockLevel': 5,
      'unit': 'pcs',
      'barcode': null,
      'supplierId': 'sup_002', // Added supplier reference
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('products', {
      'id': 'prod_003',
      'name': 'Wireless Mouse',
      'description': 'Logitech wireless optical mouse',
      'category': 'Electronics',
      'price': 1200.0,
      'costPrice': 900.0, // Added cost price
      'stockQuantity': 50,
      'minStockLevel': 10,
      'unit': 'pcs',
      'barcode': null,
      'supplierId': 'sup_001', // Added supplier reference
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
      'isGstApplicable': 1, -- Sales Tax applicable
      'gstAmount': 4250.0, -- 25000 * 17% = 4250
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
      'isGstApplicable': 1, -- Sales Tax applicable
      'gstAmount': 595.0, -- 3500 * 17% = 595
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
      'gstRate': 17.0, -- Sales Tax 17% for Pakistan
      'gstAmount': 7854.0, -- 46200 * 17% = 7854
      'total': 54054.0, -- 46200 + 7854 = 54054
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

  Future<void> _insertSampleInventoryData(Database db) async {
    // Sample suppliers
    await db.insert('suppliers', {
      'id': 'sup_001',
      'name': 'Tech Solutions Pvt Ltd',
      'contactPerson': 'Muhammad Ahmed',
      'phone': '+92 300 1111222',
      'email': 'ahmed@techsolutions.pk',
      'address': 'Plot 45, Industrial Area, Karachi',
      'ntnNumber': '1234567-8',
      'paymentTerms': '30 days',
      'creditLimit': 500000.0,
      'notes': 'Electronics and IT equipment supplier',
      'createdAt': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'totalPurchases': 150000.0,
      'pendingAmount': 25000.0,
    });

    await db.insert('suppliers', {
      'id': 'sup_002',
      'name': 'Furniture World',
      'contactPerson': 'Fatima Khan',
      'phone': '+92 321 3333444',
      'email': 'info@furnitureworld.pk',
      'address': 'Furniture Market, Lahore',
      'ntnNumber': '9876543-2',
      'paymentTerms': '15 days',
      'creditLimit': 200000.0,
      'notes': 'Office and home furniture supplier',
      'createdAt': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'totalPurchases': 80000.0,
      'pendingAmount': 0.0,
    });

    // Sample purchase order
    const poId = 'po_001';
    await db.insert('purchase_orders', {
      'id': poId,
      'orderNumber': 'PO25001',
      'supplierId': 'sup_001',
      'supplierName': 'Tech Solutions Pvt Ltd',
      'orderDate': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      'expectedDate': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'receivedDate': null,
      'subtotal': 95000.0,
      'salesTaxRate': 17.0,
      'salesTaxAmount': 16150.0,
      'total': 111150.0,
      'status': 'confirmed',
      'notes': 'Urgent order for new office setup',
      'createdAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      'updatedAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
    });

    // Sample purchase order items
    await db.insert('purchase_order_items', {
      'id': 'poi_001',
      'purchaseOrderId': poId,
      'productId': 'prod_001',
      'productName': 'Laptop HP Pavilion',
      'description': 'HP Pavilion 15-inch laptop',
      'orderedQuantity': 2,
      'receivedQuantity': 0,
      'unitPrice': 40000.0,
      'totalPrice': 80000.0,
      'unit': 'pcs',
    });

    await db.insert('purchase_order_items', {
      'id': 'poi_002',
      'purchaseOrderId': poId,
      'productId': 'prod_003',
      'productName': 'Wireless Mouse',
      'description': 'Logitech wireless mouse',
      'orderedQuantity': 25,
      'receivedQuantity': 0,
      'unitPrice': 600.0,
      'totalPrice': 15000.0,
      'unit': 'pcs',
    });

    // Sample stock movements
    await db.insert('stock_movements', {
      'id': 'mov_001',
      'productId': 'prod_001',
      'productName': 'Laptop HP Pavilion',
      'type': 'stockIn',
      'quantity': 10,
      'previousStock': 0,
      'newStock': 10,
      'unitCost': 40000.0,
      'totalValue': 400000.0,
      'reason': 'Initial stock purchase',
      'referenceId': null,
      'supplierId': 'sup_001',
      'performedBy': 'Admin',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'notes': 'Initial inventory setup',
    });

    await db.insert('stock_movements', {
      'id': 'mov_002',
      'productId': 'prod_001',
      'productName': 'Laptop HP Pavilion',
      'type': 'stockOut',
      'quantity': 1,
      'previousStock': 10,
      'newStock': 9,
      'unitCost': 40000.0,
      'totalValue': 40000.0,
      'reason': 'Sale to customer',
      'referenceId': 'inv_001',
      'supplierId': null,
      'performedBy': 'Admin',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'notes': 'Sold via invoice INV25001',
    });

    await db.insert('stock_movements', {
      'id': 'mov_003',
      'productId': 'prod_003',
      'productName': 'Wireless Mouse',
      'type': 'stockIn',
      'quantity': 50,
      'previousStock': 0,
      'newStock': 50,
      'unitCost': 900.0,
      'totalValue': 45000.0,
      'reason': 'Bulk purchase',
      'referenceId': null,
      'supplierId': 'sup_001',
      'performedBy': 'Admin',
      'createdAt': DateTime.now().subtract(const Duration(days: 25)).toIso8601String(),
      'notes': 'Bulk order for better pricing',
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
