import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../utils/database_helper.dart';

class CustomerProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Regular, Premium, VIP

  List<Customer> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  // Get customer statistics
  int get totalCustomers => _customers.length;
  int get activeCustomers => _customers.where((c) => c.pendingAmount > 0).length;
  double get totalReceivables => _customers.fold(0.0, (sum, c) => sum + c.pendingAmount);
  double get totalSales => _customers.fold(0.0, (sum, c) => sum + c.totalPurchases);

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await _databaseHelper.getCustomers();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading customers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      final id = await _databaseHelper.insertCustomer(customer);
      final newCustomer = customer.copyWith(id: id);
      _customers.add(newCustomer);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding customer: $e');
      rethrow;
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _databaseHelper.updateCustomer(customer);
      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _customers[index] = customer;
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating customer: $e');
      rethrow;
    }
  }

  Future<void> deleteCustomer(int customerId) async {
    try {
      await _databaseHelper.deleteCustomer(customerId);
      _customers.removeWhere((c) => c.id == customerId);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting customer: $e');
      rethrow;
    }
  }

  void searchCustomers(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterCustomers(String filter) {
    _selectedFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Customer> filtered = List.from(_customers);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) {
        return customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (customer.phone?.contains(_searchQuery) ?? false) ||
            (customer.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    // Apply type filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((customer) {
        return customer.customerType == _selectedFilter;
      }).toList();
    }

    // Sort by name
    filtered.sort((a, b) => a.name.compareTo(b.name));

    _filteredCustomers = filtered;
  }

  Customer? getCustomerById(int id) {
    try {
      return _customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Customer> getTopCustomers({int limit = 5}) {
    final sortedCustomers = List<Customer>.from(_customers);
    sortedCustomers.sort((a, b) => b.totalPurchases.compareTo(a.totalPurchases));
    return sortedCustomers.take(limit).toList();
  }

  List<Customer> getCustomersWithPendingPayments() {
    return _customers.where((customer) => customer.pendingAmount > 0).toList();
  }

  Future<void> updateCustomerPurchases(int customerId, double amount) async {
    final customer = getCustomerById(customerId);
    if (customer != null) {
      final updatedCustomer = customer.copyWith(
        totalPurchases: customer.totalPurchases + amount,
        updatedAt: DateTime.now(),
      );
      await updateCustomer(updatedCustomer);
    }
  }

  Future<void> updateCustomerPendingAmount(int customerId, double amount) async {
    final customer = getCustomerById(customerId);
    if (customer != null) {
      final updatedCustomer = customer.copyWith(
        pendingAmount: customer.pendingAmount + amount,
        updatedAt: DateTime.now(),
      );
      await updateCustomer(updatedCustomer);
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedFilter = 'All';
    _applyFilters();
    notifyListeners();
  }
}