class Invoice {
  final String id;
  final String invoiceNumber;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final DateTime date;
  final DateTime dueDate;
  final List<InvoiceItem> items;
  final double subtotal;
  final double gstRate; // Sales Tax Rate (Pakistan) - keeping field name for DB compatibility
  final double gstAmount; // Sales Tax Amount (Pakistan) - keeping field name for DB compatibility
  final double total;
  final String status; // 'pending', 'paid', 'overdue'
  final String? notes;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail = '',
    required this.date,
    required this.dueDate,
    required this.items,
    required this.subtotal,
    required this.gstRate,
    required this.gstAmount,
    required this.total,
    this.status = 'pending',
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'date': date.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'subtotal': subtotal,
      'gstRate': gstRate,
      'gstAmount': gstAmount,
      'total': total,
      'status': status,
      'notes': notes,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      invoiceNumber: map['invoiceNumber'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerEmail: map['customerEmail'] ?? '',
      date: DateTime.parse(map['date']),
      dueDate: DateTime.parse(map['dueDate']),
      items: [], // Items will be loaded separately
      subtotal: map['subtotal'].toDouble(),
      gstRate: map['gstRate'].toDouble(),
      gstAmount: map['gstAmount'].toDouble(),
      total: map['total'].toDouble(),
      status: map['status'],
      notes: map['notes'],
    );
  }
}

class InvoiceItem {
  final String id;
  final String invoiceId;
  final String productName;
  final String description;
  final int quantity;
  final double rate;
  final double amount;

  InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.productName,
    required this.description,
    required this.quantity,
    required this.rate,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'productName': productName,
      'description': description,
      'quantity': quantity,
      'rate': rate,
      'amount': amount,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoiceId'],
      productName: map['productName'],
      description: map['description'],
      quantity: map['quantity'],
      rate: map['rate'].toDouble(),
      amount: map['amount'].toDouble(),
    );
  }
}
