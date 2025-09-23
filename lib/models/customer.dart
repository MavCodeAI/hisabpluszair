class Customer {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? gstNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double totalPurchases;
  final double pendingAmount;
  final String customerType; // Regular, Premium, VIP
  final String? notes;

  Customer({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.gstNumber,
    required this.createdAt,
    required this.updatedAt,
    this.totalPurchases = 0.0,
    this.pendingAmount = 0.0,
    this.customerType = 'Regular',
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'gstNumber': gstNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'totalPurchases': totalPurchases,
      'pendingAmount': pendingAmount,
      'customerType': customerType,
      'notes': notes,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      gstNumber: map['gstNumber'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      totalPurchases: map['totalPurchases']?.toDouble() ?? 0.0,
      pendingAmount: map['pendingAmount']?.toDouble() ?? 0.0,
      customerType: map['customerType'] ?? 'Regular',
      notes: map['notes'],
    );
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? gstNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalPurchases,
    double? pendingAmount,
    String? customerType,
    String? notes,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      customerType: customerType ?? this.customerType,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Customer{id: $id, name: $name, phone: $phone, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode;
  }
}