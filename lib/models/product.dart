class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stockQuantity;
  final int minStockLevel;
  final String unit; // 'pcs', 'kg', 'ltr', etc.
  final String? barcode;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stockQuantity,
    required this.minStockLevel,
    required this.unit,
    this.barcode,
    required this.createdAt,
  });

  bool get isLowStock => stockQuantity <= minStockLevel;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stockQuantity': stockQuantity,
      'minStockLevel': minStockLevel,
      'unit': unit,
      'barcode': barcode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'].toDouble(),
      stockQuantity: map['stockQuantity'],
      minStockLevel: map['minStockLevel'],
      unit: map['unit'],
      barcode: map['barcode'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
