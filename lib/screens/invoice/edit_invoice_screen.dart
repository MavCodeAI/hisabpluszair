import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/invoice_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../models/invoice.dart';
import '../../models/product.dart';

class EditInvoiceScreen extends StatefulWidget {
  final Invoice invoice;

  const EditInvoiceScreen({
    super.key,
    required this.invoice,
  });

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _notesController = TextEditingController();
  
  late DateTime _selectedDate;
  late DateTime _dueDate;
  late double _gstRate;
  
  late List<InvoiceItem> _items;

  @override
  void initState() {
    super.initState();
    
    // Pre-fill all data from existing invoice
    _customerNameController.text = widget.invoice.customerName;
    _customerPhoneController.text = widget.invoice.customerPhone;
    _customerEmailController.text = widget.invoice.customerEmail;
    _notesController.text = widget.invoice.notes ?? '';
    
    _selectedDate = widget.invoice.date;
    _dueDate = widget.invoice.dueDate;
    _gstRate = widget.invoice.gstRate;
    
    // Create a copy of the items list
    _items = widget.invoice.items.map((item) => InvoiceItem(
      id: item.id,
      invoiceId: item.invoiceId,
      productName: item.productName,
      description: item.description,
      quantity: item.quantity,
      rate: item.rate,
      amount: item.amount,
    )).toList();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventoryProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Invoice ${widget.invoice.invoiceNumber}'),
        actions: [
          IconButton(
            onPressed: _updateInvoice,
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
              _buildCustomerDetails(),
              const SizedBox(height: 20),
              _buildDatesSection(),
              const SizedBox(height: 20),
              _buildItemsSection(),
              const SizedBox(height: 20),
              _buildTotalSection(),
              const SizedBox(height: 20),
              _buildNotesSection(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateInvoice,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Update Invoice',
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

  Widget _buildCustomerDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _customerEmailController,
              decoration: const InputDecoration(
                labelText: 'Email (Optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice Dates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Invoice Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_dueDate),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Invoice Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_items.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No items added yet\nTap "Add Item" to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _buildItemCard(item, index);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(InvoiceItem item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _editItem(index),
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => _removeItem(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            if (item.description.isNotEmpty)
              Text(
                item.description,
                style: TextStyle(color: Colors.grey[600]),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qty: ${item.quantity}'),
                Text('Rate: Rs.${item.rate.toStringAsFixed(2)}'),
                Text(
                  'Amount: Rs.${item.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    final subtotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    final gstAmount = (subtotal * _gstRate) / 100;
    final total = subtotal + gstAmount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              value: _gstRate,
              decoration: const InputDecoration(
                labelText: 'GST Rate (%)',
                border: OutlineInputBorder(),
              ),
              items: [0.0, 5.0, 12.0, 18.0, 28.0].map((rate) {
                return DropdownMenuItem(
                  value: rate,
                  child: Text('${rate.toStringAsFixed(0)}%'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _gstRate = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:'),
                Text('Rs.${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('GST (${_gstRate.toStringAsFixed(0)}%):'),
                Text('Rs.${gstAmount.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rs.${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Add any additional notes or terms...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isInvoiceDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate ? _selectedDate : _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isInvoiceDate) {
          _selectedDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(
        onItemAdded: (item) {
          setState(() {
            _items.add(item);
          });
        },
      ),
    );
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (context) => _EditItemDialog(
        item: _items[index],
        onItemUpdated: (updatedItem) {
          setState(() {
            _items[index] = updatedItem;
          });
        },
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _updateInvoice() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final subtotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    final gstAmount = (subtotal * _gstRate) / 100;
    final total = subtotal + gstAmount;

    final updatedInvoice = Invoice(
      id: widget.invoice.id,
      invoiceNumber: widget.invoice.invoiceNumber, // Keep original invoice number
      customerName: _customerNameController.text,
      customerPhone: _customerPhoneController.text,
      customerEmail: _customerEmailController.text,
      date: _selectedDate,
      dueDate: _dueDate,
      items: _items,
      subtotal: subtotal,
      gstRate: _gstRate,
      gstAmount: gstAmount,
      total: total,
      status: widget.invoice.status, // Keep original status
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    final invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
    invoiceProvider.updateInvoice(updatedInvoice);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invoice updated successfully'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class _AddItemDialog extends StatefulWidget {
  final Function(InvoiceItem) onItemAdded;

  const _AddItemDialog({required this.onItemAdded});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _rateController = TextEditingController();
  
  Product? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<InventoryProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<Product>(
                    value: _selectedProduct,
                    decoration: const InputDecoration(
                      labelText: 'Select Product',
                      border: OutlineInputBorder(),
                    ),
                    items: provider.products.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (product) {
                      setState(() {
                        _selectedProduct = product;
                        if (product != null) {
                          _productNameController.text = product.name;
                          _descriptionController.text = product.description;
                          _rateController.text = product.price.toString();
                        }
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
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
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      decoration: const InputDecoration(
                        labelText: 'Rate *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addItem,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final quantity = int.parse(_quantityController.text);
    final rate = double.parse(_rateController.text);
    final amount = quantity * rate;

    final item = InvoiceItem(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      invoiceId: '', // Will be set when updating invoice
      productName: _productNameController.text,
      description: _descriptionController.text,
      quantity: quantity,
      rate: rate,
      amount: amount,
    );

    widget.onItemAdded(item);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _rateController.dispose();
    super.dispose();
  }
}

class _EditItemDialog extends StatefulWidget {
  final InvoiceItem item;
  final Function(InvoiceItem) onItemUpdated;

  const _EditItemDialog({
    required this.item,
    required this.onItemUpdated,
  });

  @override
  State<_EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<_EditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();
  
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing item data
    _productNameController.text = widget.item.productName;
    _descriptionController.text = widget.item.description;
    _quantityController.text = widget.item.quantity.toString();
    _rateController.text = widget.item.rate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<InventoryProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<Product>(
                    value: _selectedProduct,
                    decoration: const InputDecoration(
                      labelText: 'Select Product',
                      border: OutlineInputBorder(),
                    ),
                    items: provider.products.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (product) {
                      setState(() {
                        _selectedProduct = product;
                        if (product != null) {
                          _productNameController.text = product.name;
                          _descriptionController.text = product.description;
                          _rateController.text = product.price.toString();
                        }
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
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
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      decoration: const InputDecoration(
                        labelText: 'Rate *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateItem,
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _updateItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final quantity = int.parse(_quantityController.text);
    final rate = double.parse(_rateController.text);
    final amount = quantity * rate;

    final updatedItem = InvoiceItem(
      id: widget.item.id,
      invoiceId: widget.item.invoiceId,
      productName: _productNameController.text,
      description: _descriptionController.text,
      quantity: quantity,
      rate: rate,
      amount: amount,
    );

    widget.onItemUpdated(updatedItem);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _rateController.dispose();
    super.dispose();
  }
}