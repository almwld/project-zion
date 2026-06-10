import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class BusinessAnalytics extends StatefulWidget {
  const BusinessAnalytics({super.key});

  @override
  State<BusinessAnalytics> createState() => _BusinessAnalyticsState();
}

class _BusinessAnalyticsState extends State<BusinessAnalytics> {
  int _selectedTab = 0;
  
  // KPI Metrics
  Map<String, KPI> _kpis = {};
  double _overallGrowth = 0;
  double _revenueTarget = 0;
  
  // Sales Analytics
  List<SalesData> _salesHistory = [];
  Map<String, double> _productPerformance = {};
  double _totalRevenue = 0;
  double _averageOrderValue = 0;
  
  // Customer Analytics
  int _totalCustomers = 0;
  int _newCustomers = 0;
  double _customerRetention = 0;
  Map<String, double> _customerSegments = {};
  
  // Financial Metrics
  Map<String, double> _financialMetrics = {};
  List<ExpenseCategory> _expenses = [];
  double _profitMargin = 0;

  @override
  void initState() {
    super.initState();
    _loadKPIs();
    _loadSalesData();
    _loadCustomerAnalytics();
    _loadFinancialMetrics();
    _startDataSimulation();
  }

  void _loadKPIs() {
    _kpis = {
      'Revenue': KPI('\$2.45M', '+15.3%', Colors.green, Icons.trending_up, 0.75),
      'Customers': KPI('12,845', '+8.2%', Colors.blue, Icons.people, 0.68),
      'Orders': KPI('45,230', '+12.7%', Colors.orange, Icons.shopping_cart, 0.72),
      'Conversion': KPI('3.45%', '+0.5%', Colors.purple, Icons.percent, 0.65),
    };
    
    _overallGrowth = 11.8;
    _revenueTarget = 87.5;
  }

  void _loadSalesData() {
    for (int i = 0; i < 12; i++) {
      _salesHistory.add(SalesData(DateTime(2024, i + 1, 1), 180000 + Random().nextDouble() * 70000));
    }
    
    _productPerformance = {
      'Product A': 35.5,
      'Product B': 28.3,
      'Product C': 22.1,
      'Product D': 14.1,
    };
    
    _totalRevenue = 2450000;
    _averageOrderValue = 54.20;
  }

  void _loadCustomerAnalytics() {
    _totalCustomers = 12845;
    _newCustomers = 1240;
    _customerRetention = 89.5;
    
    _customerSegments = {
      'Enterprise': 32,
      'SMB': 28,
      'Startup': 22,
      'Individual': 18,
    };
  }

  void _loadFinancialMetrics() {
    _financialMetrics = {
      'Gross Profit': 1250000,
      'Operating Income': 890000,
      'Net Income': 650000,
      'EBITDA': 980000,
    };
    
    _expenses = [
      ExpenseCategory('Salaries', 450000, 32, Colors.blue),
      ExpenseCategory('Marketing', 180000, 15, Colors.orange),
      ExpenseCategory('R&D', 320000, 25, Colors.green),
      ExpenseCategory('Operations', 210000, 18, Colors.purple),
      ExpenseCategory('Other', 120000, 10, Colors.grey),
    ];
    
    _profitMargin = 26.5;
  }

  void _startDataSimulation() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _totalRevenue += random.nextInt(5000);
          _newCustomers += random.nextInt(20);
          _averageOrderValue = 50 + random.nextDouble() * 10;
          _overallGrowth = 8 + random.nextDouble() * 8;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Business Analytics'),
        backgroundColor: Colors.indigo.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.trending_up), text: 'Sales'),
            Tab(icon: Icon(Icons.people), text: 'Customers'),
            Tab(icon: Icon(Icons.account_balance), text: 'Financial'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildDashboardTab(),
          _buildSalesTab(),
          _buildCustomersTab(),
          _buildFinancialTab(),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo.shade900, Colors.purple.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Overall Business Growth', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _overallGrowth / 20,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.white,
                      ),
                    ),
                    Text('${_overallGrowth.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Revenue Target: ${_revenueTarget.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: _kpis.entries.map((entry) => _buildKPICard(entry.key, entry.value)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, KPI kpi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kpi.color, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(kpi.icon, color: kpi.color, size: 32),
          const SizedBox(height: 8),
          Text(kpi.value, style: TextStyle(color: kpi.color, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(kpi.change, style: TextStyle(color: kpi.change.contains('+') ? Colors.green : Colors.red, fontSize: 12)),
          LinearProgressIndicator(
            value: kpi.progress,
            backgroundColor: Colors.grey.shade800,
            color: kpi.color,
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Revenue Trends', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade800)),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                          return Text('${value.toInt() + 1}', style: const TextStyle(color: Colors.grey));
                        })),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _salesHistory.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.revenue / 1000)).toList(),
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Product Performance', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._productPerformance.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value}%', style: const TextStyle(color: Colors.cyan)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 100,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.cyan,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSalesStat('Total Revenue', '\$${(_totalRevenue / 1000000).toStringAsFixed(1)}M', Colors.green),
                _buildSalesStat('Avg Order', '\$${_averageOrderValue.toStringAsFixed(2)}', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildCustomersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.cyan.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomerStat('Total', _formatNumber(_totalCustomers), Colors.white),
                _buildCustomerStat('New', _formatNumber(_newCustomers), Colors.green),
                _buildCustomerStat('Retention', '${_customerRetention.toStringAsFixed(1)}%', Colors.cyan),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Customer Segments', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._customerSegments.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value}%', style: const TextStyle(color: Colors.cyan)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 100,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.cyan,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade900, Colors.teal.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Profit Margin', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _profitMargin / 100,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.white,
                      ),
                    ),
                    Text('${_profitMargin.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Financial Metrics', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._financialMetrics.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('\$${(entry.value / 1000).toStringAsFixed(0)}K', style: const TextStyle(color: Colors.cyan)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 1500000,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.green,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Expense Breakdown', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._expenses.map((expense) => ListTile(
                  leading: Icon(Icons.money, color: expense.color),
                  title: Text(expense.name, style: const TextStyle(color: Colors.white)),
                  trailing: Text('\$${(expense.amount / 1000).toStringAsFixed(0)}K (${expense.percentage}%)', style: TextStyle(color: expense.color)),
                  subtitle: LinearProgressIndicator(
                    value: expense.percentage / 100,
                    backgroundColor: Colors.grey.shade800,
                    color: expense.color,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KPI {
  final String value;
  final String change;
  final Color color;
  final IconData icon;
  final double progress;

  KPI(this.value, this.change, this.color, this.icon, this.progress);
}

class SalesData {
  final DateTime date;
  final double revenue;

  SalesData(this.date, this.revenue);
}

class ExpenseCategory {
  final String name;
  final double amount;
  final double percentage;
  final Color color;

  ExpenseCategory(this.name, this.amount, this.percentage, this.color);
}
