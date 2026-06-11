import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'dart:async';

class ReportsCenter extends StatefulWidget {
  const ReportsCenter({super.key});

  @override
  State<ReportsCenter> createState() => _ReportsCenterState();
}

class _ReportsCenterState extends State<ReportsCenter> {
  int _selectedPeriod = 0; // 0: Week, 1: Month, 2: Year
  int _selectedReportType = 0; // 0: Security, 1: Network, 2: System, 3: SI Agent
  
  // إحصائيات
  int _totalAttacks = 1250;
  int _successfulAttacks = 875;
  int _failedAttacks = 375;
  int _detectedThreats = 234;
  int _blockedAttacks = 198;
  int _vulnerabilitiesFound = 67;
  int _patchedVulnerabilities = 52;
  double _securityScore = 87.5;
  
  // بيانات الرسوم البيانية
  List<FlSpot> _attackSpots = [];
  List<FlSpot> _threatSpots = [];
  List<PieSection> _attackTypes = [];
  List<PieSection> _severityLevels = [];
  
  // سجل التقارير
  List<ReportItem> _reports = [];

  @override
  void initState() {
    super.initState();
    _initChartData();
    _initPieData();
    _loadReports();
  }

  void _initChartData() {
    final random = Random();
    _attackSpots = List.generate(7, (i) => FlSpot(i.toDouble(), (random.nextInt(50) + 50).toDouble()));
    _threatSpots = List.generate(7, (i) => FlSpot(i.toDouble(), (random.nextInt(30) + 20).toDouble()));
  }

  void _initPieData() {
    _attackTypes = [
      PieSection('Port Scan', 35, Colors.cyan),
      PieSection('Brute Force', 25, Colors.orange),
      PieSection('SQL Injection', 20, Colors.red),
      PieSection('DoS', 12, Colors.purple),
      PieSection('MITM', 8, Colors.green),
    ];
    
    _severityLevels = [
      PieSection('Critical', 15, Colors.red),
      PieSection('High', 25, Colors.orange),
      PieSection('Medium', 35, Colors.yellow),
      PieSection('Low', 25, Colors.blue),
    ];
  }

  void _loadReports() {
    _reports = [
      ReportItem(
        id: '1',
        title: 'Weekly Security Report',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'Security',
        size: '1.2 MB',
        status: 'Generated',
      ),
      ReportItem(
        id: '2',
        title: 'Network Activity Report',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: 'Network',
        size: '2.5 MB',
        status: 'Generated',
      ),
      ReportItem(
        id: '3',
        title: 'SI Agent Performance',
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: 'SI Agent',
        size: '0.8 MB',
        status: 'Generated',
      ),
    ];
  }

  void _generateReport() {
    final newReport = ReportItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Report ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      date: DateTime.now(),
      type: _getReportTypeString(),
      size: '${Random().nextInt(5) + 1}.${Random().nextInt(9)} MB',
      status: 'Generated',
    );
    
    setState(() {
      _reports.insert(0, newReport);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report generated successfully!')),
    );
  }

  String _getReportTypeString() {
    switch (_selectedReportType) {
      case 0: return 'Security';
      case 1: return 'Network';
      case 2: return 'System';
      default: return 'SI Agent';
    }
  }

  void _exportReport(ReportItem report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exporting ${report.title}...')),
    );
  }

  void _deleteReport(String id) {
    setState(() {
      _reports.removeWhere((r) => r.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildPeriodSelector()),
          SliverToBoxAdapter(child: _buildStatsCards()),
          SliverToBoxAdapter(child: _buildChartsSection()),
          SliverToBoxAdapter(child: _buildPieCharts()),
          SliverToBoxAdapter(child: _buildReportGenerator()),
          SliverToBoxAdapter(child: _buildReportsList()),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Week', 'Month', 'Year'];
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(periods.length, (i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FilterChip(
            label: Text(periods[i]),
            selected: _selectedPeriod == i,
            onSelected: (selected) => setState(() => _selectedPeriod = i),
            backgroundColor: Colors.grey.shade800,
            selectedColor: Colors.indigo,
          ),
        )),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildStatCard('Total Attacks', '$_totalAttacks', Icons.flash_on, Colors.cyan),
          _buildStatCard('Success Rate', '${((_successfulAttacks / _totalAttacks) * 100).toStringAsFixed(1)}%', Icons.check_circle, Colors.green),
          _buildStatCard('Threats Detected', '$_detectedThreats', Icons.warning, Colors.orange),
          _buildStatCard('Security Score', '$_securityScore%', Icons.security, Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, color: Colors.indigo),
              SizedBox(width: 8),
              Text('Attack Trends', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade800)),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Text(days[value.toInt()], style: const TextStyle(color: Colors.grey));
                  })),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _attackSpots,
                    isCurved: true,
                    color: Colors.cyan,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: _threatSpots,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Attacks', Colors.cyan),
              const SizedBox(width: 24),
              _buildLegend('Threats', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildPieCharts() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Attack Types', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ..._attackTypes.map((type) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, color: type.color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(type.label, style: const TextStyle(color: Colors.white))),
                      Text('${type.value}%', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Severity Levels', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ..._severityLevels.map((level) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, color: level.color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(level.label, style: const TextStyle(color: Colors.white))),
                      Text('${level.value}%', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportGenerator() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generate Report', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedReportType,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Security Report')),
                    DropdownMenuItem(value: 1, child: Text('Network Report')),
                    DropdownMenuItem(value: 2, child: Text('System Report')),
                    DropdownMenuItem(value: 3, child: Text('SI Agent Report')),
                  ],
                  onChanged: (v) => setState(() => _selectedReportType = v!),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _generateReport,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: const Text('GENERATE'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    if (_reports.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No reports found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Reports', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._reports.map((report) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.description, color: Colors.indigo),
              title: Text(report.title, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${_formatDate(report.date)} • ${report.type} • ${report.size}', style: const TextStyle(color: Colors.grey)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.blue),
                    onPressed: () => _exportReport(report),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteReport(report.id),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class PieSection {
  final String label;
  final int value;
  final Color color;

  PieSection(this.label, this.value, this.color);
}

class ReportItem {
  final String id;
  final String title;
  final DateTime date;
  final String type;
  final String size;
  final String status;

  ReportItem({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    required this.size,
    required this.status,
  });
}
