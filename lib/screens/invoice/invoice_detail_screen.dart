import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/invoice.dart';
import '../../services/pdf_service.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.invoiceNumber),
        actions: [
          IconButton(
            onPressed: () => _shareInvoice(context),
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit_invoice',
                arguments: invoice,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildCustomerInfo(),
            const SizedBox(height: 20),
            _buildInvoiceDetails(),
            const SizedBox(height: 20),
            _buildItemsList(),
            const SizedBox(height: 20),
            _buildTotalSection(),
            if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildNotesSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isOverdue = invoice.status == 'pending' && 
                     invoice.dueDate.isBefore(DateTime.now());
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INVOICE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                _buildStatusChip(invoice.status, isOverdue),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Invoice Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(invoice.date),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Due Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(invoice.dueDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: isOverdue ? Colors.red : Colors.black,
                        fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bill To',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              invoice.customerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              invoice.customerPhone,
              style: const TextStyle(fontSize: 16),
            ),
            if (invoice.customerEmail.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                invoice.customerEmail,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Subtotal', 'Rs.${invoice.subtotal.toStringAsFixed(2)}'),
            _buildDetailRow('GST (${invoice.gstRate.toStringAsFixed(0)}%)', 'Rs.${invoice.gstAmount.toStringAsFixed(2)}'),
            const Divider(),
            _buildDetailRow(
              'Total Amount',
              'Rs.${invoice.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF1976D2) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 12),
            ...invoice.items.map((item) => _buildItemCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(InvoiceItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Qty: ${item.quantity}'),
              Text('Rs.${item.rate.toStringAsFixed(2)} each'),
              Text(
                'Rs.${item.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Card(
      color: const Color(0xFF1976D2).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Rs.${invoice.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              invoice.notes!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isOverdue) {
    Color color;
    String label;
    
    if (isOverdue) {
      color = Colors.red;
      label = 'Overdue';
    } else {
      switch (status) {
        case 'paid':
          color = Colors.green;
          label = 'Paid';
          break;
        case 'pending':
          color = Colors.orange;
          label = 'Pending';
          break;
        default:
          color = Colors.grey;
          label = status;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _shareInvoice(BuildContext context) async {
    try {
      await PdfService.instance.shareInvoice(invoice);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing invoice: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
