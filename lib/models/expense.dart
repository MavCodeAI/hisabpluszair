class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final String paymentMethod; // 'cash', 'card', 'upi', 'bank_transfer'
  final String? receiptPath;
  final bool isGstApplicable;
  final double gstAmount;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMethod,
    this.receiptPath,
    this.isGstApplicable = false,
    this.gstAmount = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'receiptPath': receiptPath,
      'isGstApplicable': isGstApplicable ? 1 : 0,
      'gstAmount': gstAmount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      amount: map['amount'].toDouble(),
      category: map['category'],
      date: DateTime.parse(map['date']),
      paymentMethod: map['paymentMethod'],
      receiptPath: map['receiptPath'],
      isGstApplicable: map['isGstApplicable'] == 1,
      gstAmount: map['gstAmount'].toDouble(),
    );
  }
}
