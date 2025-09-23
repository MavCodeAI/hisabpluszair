import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/expense_provider.dart';
import '../../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'cash';
  String _selectedCategory = '';
  bool _isGstApplicable = false;

  final List<String> _paymentMethods = [
    'cash',
    'card', 
    'upi',
    'bank_transfer',
  ];

  final List<String> _categories = [
    'Rent',
    'Utilities',
    'Office Supplies',
    'Travel',
    'Marketing',
    'Equipment',
    'Professional Services',
    'Food & Beverages',
    'Maintenance',
    'Insurance',
    'Taxes',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          IconButton(
            onPressed: _saveExpense,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfo(),
              const SizedBox(height: 20),
              _buildCategoryAndPayment(),
              const SizedBox(height: 20),
              _buildDateAndTax(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Add Expense',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense Title *',
                border: OutlineInputBorder(),
                hintText: 'Enter expense title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter expense title';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Enter expense description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount *',
                border: OutlineInputBorder(),
                prefixText: 'Rs. ',
                hintText: '0.00',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                  return 'Please enter valid amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAndPayment() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category & Payment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory.isEmpty ? null : _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category *',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _categoryController.text = value;
                      });
                    },
                    validator: (value) {
                      if ((value == null || value.isEmpty) && _categoryController.text.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Category',
                      border: OutlineInputBorder(),
                      hintText: 'Or type new',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method *',
                border: OutlineInputBorder(),
              ),
              items: _paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Row(
                    children: [
                      Icon(_getPaymentMethodIcon(method)),
                      const SizedBox(width: 8),
                      Text(_getPaymentMethodLabel(method)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndTax() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date & Tax Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Expense Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('GST Applicable'),
              subtitle: Text(
                _isGstApplicable
                    ? 'GST is applicable for this expense'
                    : 'No GST for this expense',
              ),
              value: _isGstApplicable,
              onChanged: (value) {
                setState(() {
                  _isGstApplicable = value;
                });
              },
              activeColor: const Color(0xFF1976D2),
            ),
            if (_isGstApplicable) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GST Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'GST amount will be calculated at 18% of the expense amount.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    if (_amountController.text.isNotEmpty && double.tryParse(_amountController.text) != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'GST Amount: Rs.${(double.parse(_amountController.text) * 0.18).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'upi':
        return Icons.qr_code;
      case 'bank_transfer':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodLabel(String method) {
    switch (method) {
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Card';
      case 'upi':
        return 'UPI';
      case 'bank_transfer':
        return 'Bank Transfer';
      default:
        return method;
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);
    final gstAmount = _isGstApplicable ? amount * 0.18 : 0.0;
    
    final expense = Expense(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: amount,
      category: _selectedCategory.isNotEmpty ? _selectedCategory : _categoryController.text.trim(),
      date: _selectedDate,
      paymentMethod: _selectedPaymentMethod,
      isGstApplicable: _isGstApplicable,
      gstAmount: gstAmount,
    );

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense added successfully'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}
