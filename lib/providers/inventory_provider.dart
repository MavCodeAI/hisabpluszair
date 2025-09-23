import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../utils/database_helper.dart';

class InventoryProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  List<Product> get lowStockProducts {
    return _products.where((product) => product.isLowStock).toList();
  }

  double get totalInventoryValue {
    return _products.fold(0.0, (sum, product) => sum + (product.price * product.stockQuantity));
  }

  List<String> get categories {
    return _products.map((product) => product.category).toSet().toList();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query('products');
      
      _products = maps.map((map) => Product.fromMap(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading products: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('products', product.toMap());
      
      _products.add(product);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding product: $e');
      }
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating product: $e');
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('products', where: 'id = ?', whereArgs: [productId]);
      
      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting product: $e');
      }
    }
  }

  Future<void> updateStock(String productId, int newQuantity) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'products',
        {'stockQuantity': newQuantity},
        where: 'id = ?',
        whereArgs: [productId],
      );

      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final product = _products[index];
        _products[index] = Product(
          id: product.id,
          name: product.name,
          description: product.description,
          category: product.category,
          price: product.price,
          stockQuantity: newQuantity,
          minStockLevel: product.minStockLevel,
          unit: product.unit,
          barcode: product.barcode,
          createdAt: product.createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating stock: $e');
      }
    }
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
             product.description.toLowerCase().contains(query.toLowerCase()) ||
             product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }
}
