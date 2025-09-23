import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/invoice_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/inventory_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedTabIndex = 0;
  DateTime _selectedPeriod = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
      
      invoiceProvider.loadInvoices();
      expenseProvider.loadExpenses();
      inventoryProvider.loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          _buildPeriodSelector(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('Sales', 0),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton('Expenses', 1),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton('Inventory', 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Period: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: _selectPeriod,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedPeriod),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildSalesReport();
      case 1:
        return _buildExpenseReport();
      case 2:
        return _buildInventoryReport();
      default:
        return _buildSalesReport();
    }
  }

  Widget _buildSalesReport() {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSalesMetrics(provider),
              const SizedBox(height: 20),
              _buildSalesChart(provider),
              const SizedBox(height: 20),
              _buildRecentInvoices(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSalesMetrics(InvoiceProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Sales',
                    'Rs.${provider.totalSales.toStringAsFixed(2)}',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Pending Amount',
                    'Rs.${provider.pendingAmount.toStringAsFixed(2)}',
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Invoices',
                    '${provider.invoices.length}',
                    Icons.receipt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Overdue',
                    '${provider.overdueInvoices.length}',
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseReport() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExpenseMetrics(provider),
              const SizedBox(height: 20),
              _buildExpenseByCategoryChart(provider),
              const SizedBox(height: 20),
              _buildExpenseCategories(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInventoryReport() {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInventoryMetrics(provider),
              const SizedBox(height: 20),
              _buildLowStockAlert(provider),
              const SizedBox(height: 20),
              _buildTopProducts(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart(InvoiceProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSalesSpots(provider),
                      isCurved: true,
                      color: const Color(0xFF1976D2),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF1976D2).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseByCategoryChart(ExpenseProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expenses by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _generateExpenseSections(provider),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseMetrics(ExpenseProvider provider) {
    final monthlyExpenses = provider.getMonthlyExpenses(_selectedPeriod);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'This Month',
                    'Rs.${monthlyExpenses.toStringAsFixed(2)}',
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Total Expenses',
                    'Rs.${provider.totalExpenses.toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryMetrics(InventoryProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Products',
                    '${provider.products.length}',
                    Icons.inventory,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Low Stock Items',
                    '${provider.lowStockProducts.length}',
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Value',
                    'Rs.${provider.totalInventoryValue.toStringAsFixed(0)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Categories',
                    '${provider.categories.length}',
                    Icons.category,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentInvoices(InvoiceProvider provider) {
    final recentInvoices = provider.invoices.take(5).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Invoices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...recentInvoices.map((invoice) => ListTile(
              leading: CircleAvatar(
                backgroundColor: invoice.status == 'paid'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                child: Icon(
                  invoice.status == 'paid' ? Icons.check : Icons.pending,
                  color: invoice.status == 'paid' ? Colors.green : Colors.orange,
                ),
              ),
              title: Text(invoice.invoiceNumber),
              subtitle: Text(invoice.customerName),
              trailing: Text('Rs.${invoice.total.toStringAsFixed(2)}'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCategories(ExpenseProvider provider) {
    final categoryExpenses = provider.expensesByCategory;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Expense Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...categoryExpenses.entries.take(5).map((entry) => ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.category, color: Colors.white),
              ),
              title: Text(entry.key),
              trailing: Text('Rs.${entry.value.toStringAsFixed(2)}'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockAlert(InventoryProvider provider) {
    final lowStockProducts = provider.lowStockProducts;
    
    if (lowStockProducts.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 8),
              Text(
                'All products are well stocked!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Low Stock Alert',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...lowStockProducts.take(5).map((product) => ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.warning, color: Colors.white),
              ),
              title: Text(product.name),
              subtitle: Text('Stock: ${product.stockQuantity} ${product.unit}'),
              trailing: Text(
                'Min: ${product.minStockLevel}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducts(InventoryProvider provider) {
    final products = provider.products;
    products.sort((a, b) => (b.price * b.stockQuantity).compareTo(a.price * a.stockQuantity));
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Products by Value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...products.take(5).map((product) => ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
                child: const Icon(Icons.inventory, color: Color(0xFF1976D2)),
              ),
              title: Text(product.name),
              subtitle: Text('Stock: ${product.stockQuantity} ${product.unit}'),
              trailing: Text('Rs.${(product.price * product.stockQuantity).toStringAsFixed(0)}'),
            )),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSalesSpots(InvoiceProvider provider) {
    // This is a simplified example - in a real app, you'd generate this from actual data
    return [
      const FlSpot(0, 3),
      const FlSpot(1, 1),
      const FlSpot(2, 4),
      const FlSpot(3, 2),
      const FlSpot(4, 5),
      const FlSpot(5, 3),
      const FlSpot(6, 4),
    ];
  }

  List<PieChartSectionData> _generateExpenseSections(ExpenseProvider provider) {
    final categoryExpenses = provider.expensesByCategory;
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
    
    return categoryExpenses.entries.take(5).toList().asMap().entries.map((entry) {
      final index = entry.key;
      final categoryEntry = entry.value;
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: categoryEntry.value,
        title: '${((categoryEntry.value / provider.totalExpenses) * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  void _selectPeriod() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPeriod,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedPeriod = DateTime(picked.year, picked.month);
      });
    }
  }
}
