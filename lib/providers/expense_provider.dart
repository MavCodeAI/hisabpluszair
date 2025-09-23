import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../utils/database_helper.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  double get totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> get expensesByCategory {
    final Map<String, double> categoryExpenses = {};
    for (final expense in _expenses) {
      categoryExpenses[expense.category] = 
          (categoryExpenses[expense.category] ?? 0) + expense.amount;
    }
    return categoryExpenses;
  }

  List<String> get categories {
    return _expenses.map((expense) => expense.category).toSet().toList();
  }

  double getMonthlyExpenses(DateTime month) {
    return _expenses.where((expense) {
      return expense.date.year == month.year && expense.date.month == month.month;
    }).fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query('expenses');
      
      _expenses = maps.map((map) => Expense.fromMap(map)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading expenses: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('expenses', expense.toMap());
      
      _expenses.add(expense);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding expense: $e');
      }
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'expenses',
        expense.toMap(),
        where: 'id = ?',
        whereArgs: [expense.id],
      );

      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating expense: $e');
      }
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('expenses', where: 'id = ?', whereArgs: [expenseId]);
      
      _expenses.removeWhere((expense) => expense.id == expenseId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting expense: $e');
      }
    }
  }

  List<Expense> getExpensesByDateRange(DateTime startDate, DateTime endDate) {
    return _expenses.where((expense) {
      return expense.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
             expense.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }
}
