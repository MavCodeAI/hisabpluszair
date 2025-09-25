import 'dart:typed_data';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/invoice.dart';

class PdfService {
  static final PdfService instance = PdfService._internal();
  PdfService._internal();

  // ===== INVOICE PDF GENERATION =====
  Future<Uint8List> generateInvoicePDF(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            _buildInvoiceHeader(invoice),
            pw.SizedBox(height: 20),
            
            // Customer Info
            _buildCustomerInfo(invoice),
            pw.SizedBox(height: 20),
            
            // Invoice Items
            _buildInvoiceItems(invoice),
            pw.SizedBox(height: 20),
            
            // Total Section
            _buildTotalSection(invoice),
            pw.SizedBox(height: 20),
            
            // Footer
            _buildInvoiceFooter(invoice),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildInvoiceHeader(Invoice invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColors.blue600, PdfColors.blue400],
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'HisaabPlus',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.Text(
                'Professional Invoice',
                style: const pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.Text(
                invoice.invoiceNumber,
                style: const pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCustomerInfo(Invoice invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Bill To:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue600,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                invoice.customerName,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(invoice.customerPhone),
              if (invoice.customerEmail.isNotEmpty)
                pw.Text(invoice.customerEmail),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Invoice Details:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue600,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Date: ${invoice.date.toString().split(' ')[0]}'),
              pw.Text('Due Date: ${invoice.dueDate.toString().split(' ')[0]}'),
              pw.Text('Status: ${invoice.status.toUpperCase()}'),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildInvoiceItems(Invoice invoice) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Item', isHeader: true),
            _buildTableCell('Qty', isHeader: true),
            _buildTableCell('Rate', isHeader: true),
            _buildTableCell('Amount', isHeader: true),
          ],
        ),
        // Items
        ...invoice.items.map((item) => pw.TableRow(
          children: [
            _buildTableCell(item.productName),
            _buildTableCell('${item.quantity}'),
            _buildTableCell('Rs.${item.rate.toStringAsFixed(2)}'),
            _buildTableCell('Rs.${item.amount.toStringAsFixed(2)}'),
          ],
        )),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 12 : 11,
        ),
      ),
    );
  }

  pw.Widget _buildTotalSection(Invoice invoice) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 250,
        child: pw.Column(
          children: [
            _buildTotalRow('Subtotal:', 'Rs.${invoice.subtotal.toStringAsFixed(2)}'),
            _buildTotalRow('Sales Tax (${invoice.gstRate.toStringAsFixed(0)}%):', 'Rs.${invoice.gstAmount.toStringAsFixed(2)}'),
            pw.Divider(),
            _buildTotalRow(
              'Total:',
              'Rs.${invoice.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceFooter(Invoice invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Notes:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(invoice.notes ?? 'Thank you for your business!'),
          pw.SizedBox(height: 10),
          pw.Text(
            'Terms & Conditions:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text('• Payment is due within 30 days'),
          pw.Text('• Late fees may apply for overdue payments'),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'HisaabPlus - Pakistani Business Management Solution',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== PDF ACTIONS =====
  Future<void> printInvoice(Invoice invoice) async {
    final pdfData = await generateInvoicePDF(invoice);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

  Future<void> shareInvoice(Invoice invoice) async {
    final pdfData = await generateInvoicePDF(invoice);
    await Printing.sharePdf(
      bytes: pdfData,
      filename: 'invoice_${invoice.invoiceNumber}.pdf',
    );
  }

  Future<String> saveInvoiceToFile(Invoice invoice) async {
    final pdfData = await generateInvoicePDF(invoice);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/invoice_${invoice.invoiceNumber}.pdf');
    await file.writeAsBytes(pdfData);
    return file.path;
  }

  // ===== SALES REPORT PDF =====
  Future<Uint8List> generateSalesReportPDF({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, dynamic> summary,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Period: ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}'),
              pw.SizedBox(height: 20),
              pw.Text('Total Sales: Rs.${summary['totalSales']?.toStringAsFixed(2) ?? '0.00'}'),
              pw.Text('Total Orders: ${summary['totalOrders'] ?? 0}'),
              pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}