import 'package:flutter/foundation.dart';
import '../models/invoice.dart';
import '../utils/database_helper.dart';

class InvoiceProvider with ChangeNotifier {
  List<Invoice> _invoices = [];
  bool _isLoading = false;

  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;

  double get totalSales {
    return _invoices
        .where((invoice) => invoice.status == 'paid')
        .fold(0.0, (sum, invoice) => sum + invoice.total);
  }

  double get pendingAmount {
    return _invoices
        .where((invoice) => invoice.status == 'pending')
        .fold(0.0, (sum, invoice) => sum + invoice.total);
  }

  List<Invoice> get overdueInvoices {
    final now = DateTime.now();
    return _invoices
        .where((invoice) => 
            invoice.status == 'pending' && invoice.dueDate.isBefore(now))
        .toList();
  }

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query('invoices');
      
      _invoices = maps.map((map) => Invoice.fromMap(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading invoices: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addInvoice(Invoice invoice) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('invoices', invoice.toMap());
      
      // Insert invoice items
      for (final item in invoice.items) {
        await db.insert('invoice_items', item.toMap());
      }
      
      _invoices.add(invoice);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding invoice: $e');
      }
    }
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    try {
      final db = await DatabaseHelper.instance.database;
      
      // Update the invoice
      await db.update(
        'invoices',
        updatedInvoice.toMap(),
        where: 'id = ?',
        whereArgs: [updatedInvoice.id],
      );
      
      // Delete existing invoice items
      await db.delete(
        'invoice_items',
        where: 'invoiceId = ?',
        whereArgs: [updatedInvoice.id],
      );
      
      // Insert updated invoice items
      for (final item in updatedInvoice.items) {
        await db.insert('invoice_items', item.toMap());
      }
      
      final index = _invoices.indexWhere((invoice) => invoice.id == updatedInvoice.id);
      if (index != -1) {
        _invoices[index] = updatedInvoice;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating invoice: $e');
      }
    }
  }

  Future<void> updateInvoiceStatus(String invoiceId, String status) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'invoices',
        {'status': status},
        where: 'id = ?',
        whereArgs: [invoiceId],
      );

      final index = _invoices.indexWhere((invoice) => invoice.id == invoiceId);
      if (index != -1) {
        final invoice = _invoices[index];
        _invoices[index] = Invoice(
          id: invoice.id,
          invoiceNumber: invoice.invoiceNumber,
          customerName: invoice.customerName,
          customerPhone: invoice.customerPhone,
          customerEmail: invoice.customerEmail,
          date: invoice.date,
          dueDate: invoice.dueDate,
          items: invoice.items,
          subtotal: invoice.subtotal,
          gstRate: invoice.gstRate,
          gstAmount: invoice.gstAmount,
          total: invoice.total,
          status: status,
          notes: invoice.notes,
        );
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating invoice status: $e');
      }
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('invoices', where: 'id = ?', whereArgs: [invoiceId]);
      await db.delete('invoice_items', where: 'invoiceId = ?', whereArgs: [invoiceId]);
      
      _invoices.removeWhere((invoice) => invoice.id == invoiceId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting invoice: $e');
      }
    }
  }

  String generateInvoiceNumber() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final count = _invoices.length + 1;
    return 'INV$year$month${count.toString().padLeft(3, '0')}';
  }
}
