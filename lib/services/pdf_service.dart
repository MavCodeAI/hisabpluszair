import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/invoice.dart';

class PDFService {
  static Future<Uint8List> generateInvoicePDF(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Professional Header with HisaabPlus Branding
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                gradient: const pw.LinearGradient(
                  colors: [PdfColors.blue700, PdfColors.blue500],
                ),
                borderRadius: pw.BorderRadius.circular(12),
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
                        'حساب پلس',
                        style: pw.TextStyle(
                          fontSize: 18,
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
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.Text(
                        '${invoice.invoiceNumber}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 30),

            // Company Info - Updated for Pakistani Business
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(10),
                color: PdfColors.grey50,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'آپ کا کاروباری نام',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue700,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text('کاروباری پتہ - پاکستان'),
                  pw.Text('فون: +92 300 1234567'),
                  pw.Text('ای میل: business@hisaabplus.pk'),
                  pw.Text('NTN: 1234567-8'),
                ],
              ),
            ),

            pw.SizedBox(height: 25),

            // Customer and Invoice Info
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Customer Info
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.blue200),
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColors.blue50,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'بل کا پتہ:',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                            color: PdfColors.blue700,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(invoice.customerName, style: pw.TextStyle(fontSize: 13)),
                        pw.Text('فون: ${invoice.customerPhone}', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('ای میل: ${invoice.customerEmail}', style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 20),
                // Invoice Details
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.green200),
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColors.green50,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'انوائس کی تفصیلات:',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                            color: PdfColors.green700,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'تاریخ: ${invoice.date.toString().split(' ')[0]}',
                          style: pw.TextStyle(fontSize: 12),
                        ),
                        pw.Text(
                          'آخری تاریخ: ${invoice.dueDate.toString().split(' ')[0] ?? 'N/A'}',
                          style: pw.TextStyle(fontSize: 12),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: pw.BoxDecoration(
                            color: invoice.status == 'Paid' 
                                ? PdfColors.green
                                : invoice.status == 'Pending'
                                    ? PdfColors.orange
                                    : PdfColors.red,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            'حالت: ${invoice.status}',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 30),

            // Professional Items Table Header
            pw.Text(
              'اشیاء کی تفصیلات:',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue700,
              ),
            ),
            pw.SizedBox(height: 15),

            // Modern Items Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.blue300, width: 1.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1.5),
              },
              children: [
                // Professional Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.blue700,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Text(
                        'اشیاء',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Text(
                        'تعداد',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Text(
                        'ریٹ (Rs.)',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Text(
                        'رقم (Rs.)',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                // Professional Items Rows
                ...invoice.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isEven = index % 2 == 0;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: isEven ? PdfColors.blue50 : PdfColors.white,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          item['name'] ?? '',
                          style: pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          '${item['quantity'] ?? 0}',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Rs. ${item['price'] ?? 0}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Rs. ${(item['quantity'] ?? 0) * (item['price'] ?? 0)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 25),

            // Professional Totals Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Payment Terms
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColors.grey50,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'ادائیگی کی شرائط:',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            color: PdfColors.blue700,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text('• نقد / بینک ٹرانسفر', style: pw.TextStyle(fontSize: 10)),
                        pw.Text('• تمام اخراجات شامل', style: pw.TextStyle(fontSize: 10)),
                        pw.Text('• ادائیگی کی تاریخ کے بعد سود', style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 20),
                // Totals
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.green300, width: 2),
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColors.green50,
                    ),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ذیلی ٹوٹل:', style: pw.TextStyle(fontSize: 12)),
                            pw.Text('Rs. ${invoice.subtotal.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ٹیکس:', style: pw.TextStyle(fontSize: 12)),
                            pw.Text('Rs. ${invoice.tax.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                        pw.Divider(thickness: 2, color: PdfColors.green700),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'کل رقم:',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16,
                                color: PdfColors.green700,
                              ),
                            ),
                            pw.Text(
                              'Rs. ${invoice.total.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16,
                                color: PdfColors.green700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 30),

            // Footer with HisaabPlus Branding
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue700,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'شکریہ! HisaabPlus کا انتخاب کرنے کے لیے',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'www.hisaabplus.pk | پاکستانی کاروبار کا ڈجیٹل شریک',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
                        pw.Text('Rs. ${invoice.tax.toStringAsFixed(2)}'),
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total:',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Rs. ${invoice.total.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 30),

            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey50,
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
                  pw.Text('Payment is due within 30 days.'),
                  pw.Text('Late fees may apply for overdue payments.'),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

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
      filename: 'invoice_${invoice.id}.pdf',
    );
  }

  Future<String> saveInvoiceToFile(Invoice invoice) async {
    final pdfData = await generateInvoicePDF(invoice);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/invoice_${invoice.id}.pdf');
    await file.writeAsBytes(pdfData);
    return file.path;
  }

  // ===== SALES REPORT PDF =====
  Future<Uint8List> generateSalesReportPDF({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required List<Map<String, dynamic>> salesData,
    required Map<String, dynamic> summary,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            _buildReportHeader(title, startDate, endDate),
            pw.SizedBox(height: 20),
            
            // Summary Cards
            _buildSummarySection(summary),
            pw.SizedBox(height: 20),
            
            // Sales Data Table
            _buildSalesTable(salesData),
            pw.SizedBox(height: 20),
            
            // Footer
            _buildReportFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ===== TAX REPORT PDF =====
  Future<Uint8List> generateTaxReportPDF({
    required String period,
    required Map<String, dynamic> gstData,
    required List<Map<String, dynamic>> transactions,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.red50,
                border: pw.Border.all(color: PdfColors.red500),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'GST Report - $period',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // GST Summary
            _buildGSTSummary(gstData),
            pw.SizedBox(height: 20),
            
            // Transaction Details
            _buildTaxTransactionTable(transactions),
            
            // Footer
            _buildReportFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ===== CUSTOMER STATEMENT PDF =====
  Future<Uint8List> generateCustomerStatementPDF({
    required Map<String, dynamic> customer,
    required List<Map<String, dynamic>> transactions,
    required Map<String, dynamic> summary,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                border: pw.Border.all(color: PdfColors.green500),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Customer Statement',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Customer: ${customer['name']}'),
                  pw.Text('CNIC: ${customer['cnic'] ?? 'N/A'}'),
                  pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Customer Summary
            _buildCustomerSummary(summary),
            pw.SizedBox(height: 20),
            
            // Transaction History
            _buildCustomerTransactionTable(transactions),
            
            // Footer
            _buildReportFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ===== INVENTORY REPORT PDF =====
  Future<Uint8List> generateInventoryReportPDF({
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> summary,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.purple50,
                border: pw.Border.all(color: PdfColors.purple500),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Inventory Report',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Inventory Summary
            _buildInventorySummary(summary),
            pw.SizedBox(height: 20),
            
            // Product Details
            _buildInventoryTable(products),
            
            // Footer
            _buildReportFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ===== PROFIT & LOSS STATEMENT PDF =====
  Future<Uint8List> generateProfitLossStatementPDF({
    required String period,
    required Map<String, dynamic> revenue,
    required Map<String, dynamic> expenses,
    required Map<String, dynamic> summary,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                border: pw.Border.all(color: PdfColors.orange500),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Profit & Loss Statement',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Period: $period'),
                  pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Revenue Section
            _buildPLSection('REVENUE', revenue),
            pw.SizedBox(height: 15),
            
            // Expenses Section
            _buildPLSection('EXPENSES', expenses),
            pw.SizedBox(height: 15),
            
            // Summary Section
            _buildPLSummary(summary),
            
            // Footer
            _buildReportFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ===== HELPER FUNCTIONS =====
  pw.Widget _buildReportHeader(String title, DateTime startDate, DateTime endDate) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColors.blue700, PdfColors.blue500],
        ),
        borderRadius: pw.BorderRadius.circular(12),
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
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Period: ${startDate.day}/${startDate.month}/${startDate.year}',
                style: pw.TextStyle(color: PdfColors.white, fontSize: 12),
              ),
              pw.Text(
                'to ${endDate.day}/${endDate.month}/${endDate.year}',
                style: pw.TextStyle(color: PdfColors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummarySection(Map<String, dynamic> summary) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _buildSummaryCard('Total Sales', 'Rs. ${summary['totalSales'] ?? 0}', PdfColors.green),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _buildSummaryCard('Total Invoices', '${summary['totalInvoices'] ?? 0}', PdfColors.blue),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _buildSummaryCard('Average Sale', 'Rs. ${summary['averageSale'] ?? 0}', PdfColors.orange),
        ),
      ],
    );
  }

  pw.Widget _buildSummaryCard(String title, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: color.shade(0.1),
        border: pw.Border.all(color: color),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text(value, style: pw.TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  pw.Widget _buildSalesTable(List<Map<String, dynamic>> salesData) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Date', isHeader: true),
            _buildTableCell('Invoice #', isHeader: true),
            _buildTableCell('Customer', isHeader: true),
            _buildTableCell('Amount', isHeader: true),
          ],
        ),
        // Data rows
        ...salesData.map((sale) => pw.TableRow(
          children: [
            _buildTableCell(sale['date'] ?? ''),
            _buildTableCell(sale['invoiceNumber'] ?? ''),
            _buildTableCell(sale['customer'] ?? ''),
            _buildTableCell('Rs. ${sale['amount'] ?? 0}'),
          ],
        )),
      ],
    );
  }

  pw.Widget _buildGSTSummary(Map<String, dynamic> gstData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.red50,
        border: pw.Border.all(color: PdfColors.red300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Sales:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Rs. ${gstData['totalSales'] ?? 0}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('GST Collected (17%):', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Rs. ${gstData['gstCollected'] ?? 0}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('GST Paid on Purchases:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Rs. ${gstData['gstPaid'] ?? 0}'),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Net GST Payable:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
              pw.Text('Rs. ${gstData['netGST'] ?? 0}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTaxTransactionTable(List<Map<String, dynamic>> transactions) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Date', isHeader: true),
            _buildTableCell('Type', isHeader: true),
            _buildTableCell('Amount', isHeader: true),
            _buildTableCell('GST', isHeader: true),
          ],
        ),
        // Data rows
        ...transactions.map((txn) => pw.TableRow(
          children: [
            _buildTableCell(txn['date'] ?? ''),
            _buildTableCell(txn['type'] ?? ''),
            _buildTableCell('Rs. ${txn['amount'] ?? 0}'),
            _buildTableCell('Rs. ${txn['gst'] ?? 0}'),
          ],
        )),
      ],
    );
  }

  pw.Widget _buildCustomerSummary(Map<String, dynamic> summary) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _buildSummaryCard('Total Purchases', 'Rs. ${summary['totalPurchases'] ?? 0}', PdfColors.green),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _buildSummaryCard('Outstanding', 'Rs. ${summary['outstanding'] ?? 0}', PdfColors.red),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _buildSummaryCard('Last Payment', '${summary['lastPayment'] ?? 'N/A'}', PdfColors.blue),
        ),
      ],
    );
  }

  pw.Widget _buildCustomerTransactionTable(List<Map<String, dynamic>> transactions) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Date', isHeader: true),
            _buildTableCell('Description', isHeader: true),
            _buildTableCell('Debit', isHeader: true),
            _buildTableCell('Credit', isHeader: true),
            _buildTableCell('Balance', isHeader: true),
          ],
        ),
        // Data rows
        ...transactions.map((txn) => pw.TableRow(
          children: [
            _buildTableCell(txn['date'] ?? ''),
            _buildTableCell(txn['description'] ?? ''),
            _buildTableCell(txn['debit'] != null ? 'Rs. ${txn['debit']}' : ''),
            _buildTableCell(txn['credit'] != null ? 'Rs. ${txn['credit']}' : ''),
            _buildTableCell('Rs. ${txn['balance'] ?? 0}'),
          ],
        )),
      ],
    );
  }

  pw.Widget _buildInventorySummary(Map<String, dynamic> summary) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _buildSummaryCard('Total Products', '${summary['totalProducts'] ?? 0}', PdfColors.purple),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _buildSummaryCard('Total Value', 'Rs. ${summary['totalValue'] ?? 0}', PdfColors.green),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _buildSummaryCard('Low Stock Items', '${summary['lowStockItems'] ?? 0}', PdfColors.red),
        ),
      ],
    );
  }

  pw.Widget _buildInventoryTable(List<Map<String, dynamic>> products) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildTableCell('Product', isHeader: true),
            _buildTableCell('Stock', isHeader: true),
            _buildTableCell('Unit Price', isHeader: true),
            _buildTableCell('Total Value', isHeader: true),
          ],
        ),
        // Data rows
        ...products.map((product) => pw.TableRow(
          children: [
            _buildTableCell(product['name'] ?? ''),
            _buildTableCell('${product['stock'] ?? 0}'),
            _buildTableCell('Rs. ${product['unitPrice'] ?? 0}'),
            _buildTableCell('Rs. ${product['totalValue'] ?? 0}'),
          ],
        )),
      ],
    );
  }

  pw.Widget _buildPLSection(String title, Map<String, dynamic> data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: title == 'REVENUE' ? PdfColors.green50 : PdfColors.red50,
        border: pw.Border.all(color: title == 'REVENUE' ? PdfColors.green300 : PdfColors.red300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...data.entries.map((entry) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(entry.key),
              pw.Text('Rs. ${entry.value}'),
            ],
          )),
        ],
      ),
    );
  }

  pw.Widget _buildPLSummary(Map<String, dynamic> summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue500),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Revenue:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Rs. ${summary['totalRevenue'] ?? 0}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Expenses:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Rs. ${summary['totalExpenses'] ?? 0}'),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Net Profit/Loss:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
              pw.Text(
                'Rs. ${summary['netProfit'] ?? 0}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                  color: (summary['netProfit'] ?? 0) >= 0 ? PdfColors.green : PdfColors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildReportFooter() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Generated by HisaabPlus - Smart Business Management',
            style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
          ),
          pw.Text(
            'Date: ${DateTime.now().toString().split('.')[0]}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  // ===== UTILITY FUNCTIONS =====
  Future<void> printReport(Uint8List pdfData, String filename) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

  Future<void> shareReport(Uint8List pdfData, String filename) async {
    await Printing.sharePdf(
      bytes: pdfData,
      filename: filename,
    );
  }

  Future<String> saveReportToFile(Uint8List pdfData, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(pdfData);
    return file.path;
  }
}