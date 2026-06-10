import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class QualityAssuranceCenter extends StatefulWidget {
  const QualityAssuranceCenter({super.key});

  @override
  State<QualityAssuranceCenter> createState() => _QualityAssuranceCenterState();
}

class _QualityAssuranceCenterState extends State<QualityAssuranceCenter> {
  int _selectedTab = 0;
  
  // Quality Metrics
  double _overallQualityScore = 0;
  double _codeQuality = 0;
  double _performanceScore = 0;
  double _securityScore = 0;
  double _usabilityScore = 0;
  double _reliabilityScore = 0;
  
  // Test Results
  List<TestResult> _testResults = [];
  int _totalTests = 0;
  int _passedTests = 0;
  int _failedTests = 0;
  double _testCoverage = 0;
  
  // Performance Metrics
  List<PerformanceMetric> _performanceMetrics = [];
  Map<String, double> _responseTimes = {};
  Map<String, double> _errorRates = {};
  
  // Compliance
  List<ComplianceItem> _complianceItems = [];
  double _complianceScore = 0;
  List<String> _nonCompliantItems = [];

  @override
  void initState() {
    super.initState();
    _loadQualityMetrics();
    _loadTestResults();
    _loadPerformanceMetrics();
    _loadCompliance();
    _startMonitoring();
  }

  void _loadQualityMetrics() {
    _overallQualityScore = 87.5;
    _codeQuality = 92.3;
    _performanceScore = 85.7;
    _securityScore = 88.9;
    _usabilityScore = 91.2;
    _reliabilityScore = 84.6;
  }

  void _loadTestResults() {
    _testResults = [
      TestResult('Unit Tests', 245, 235, 10, 96, DateTime.now().subtract(const Duration(hours: 2))),
      TestResult('Integration Tests', 89, 82, 7, 92, DateTime.now().subtract(const Duration(hours: 5))),
      TestResult('E2E Tests', 34, 30, 4, 88, DateTime.now().subtract(const Duration(days: 1))),
      TestResult('Security Tests', 56, 52, 4, 93, DateTime.now().subtract(const Duration(days: 2))),
      TestResult('Performance Tests', 42, 38, 4, 90, DateTime.now().subtract(const Duration(days: 3))),
    ];
    
    _totalTests = _testResults.map((t) => t.total).reduce((a, b) => a + b);
    _passedTests = _testResults.map((t) => t.passed).reduce((a, b) => a + b);
    _failedTests = _testResults.map((t) => t.failed).reduce((a, b) => a + b);
    _testCoverage = (_passedTests / _totalTests) * 100;
  }

  void _loadPerformanceMetrics() {
    _performanceMetrics = [
      PerformanceMetric('API Response', 245, 89, 320, 'ms', Colors.cyan),
      PerformanceMetric('Page Load', 1.2, 0.8, 2.1, 's', Colors.green),
      PerformanceMetric('Database Query', 45, 12, 78, 'ms', Colors.orange),
      PerformanceMetric('Memory Usage', 256, 128, 512, 'MB', Colors.purple),
    ];
    
    _responseTimes = {
      'Login': 234,
      'Search': 189,
      'Save': 312,
      'Export': 456,
    };
    
    _errorRates = {
      'API': 0.5,
      'Database': 0.2,
      'Frontend': 0.8,
      'Auth': 0.3,
    };
  }

  void _loadCompliance() {
    _complianceItems = [
      ComplianceItem('ISO 27001', 92, 'Compliant', Icons.security, Colors.green),
      ComplianceItem('GDPR', 88, 'Partial', Icons.privacy_tip, Colors.orange),
      ComplianceItem('SOC 2', 95, 'Compliant', Icons.verified, Colors.green),
      ComplianceItem('PCI DSS', 78, 'Non-Compliant', Icons.credit_card, Colors.red),
      ComplianceItem('HIPAA', 85, 'Partial', Icons.health_and_safety, Colors.orange),
    ];
    
    _complianceScore = _complianceItems.map((c) => c.score).reduce((a, b) => a + b) / _complianceItems.length;
    _nonCompliantItems = _complianceItems.where((c) => c.status != 'Compliant').map((c) => c.name).toList();
  }

  void _startMonitoring() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _performanceScore = 80 + random.nextDouble() * 15;
          _overallQualityScore = (_codeQuality + _performanceScore + _securityScore + _usabilityScore + _reliabilityScore) / 5;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Quality Assurance'),
        backgroundColor: Colors.teal.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.quality), text: 'Quality'),
            Tab(icon: Icon(Icons.bug_report), text: 'Tests'),
            Tab(icon: Icon(Icons.speed), text: 'Performance'),
            Tab(icon: Icon(Icons.verified), text: 'Compliance'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildQualityTab(),
          _buildTestsTab(),
          _buildPerformanceTab(),
          _buildComplianceTab(),
        ],
      ),
    );
  }

  Widget _buildQualityTab() {
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
                colors: [Colors.teal.shade900, Colors.blue.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Overall Quality Score', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: _overallQualityScore / 100,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.white,
                      ),
                    ),
                    Text('${_overallQualityScore.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
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
            children: [
              _buildQualityCard('Code Quality', _codeQuality, Icons.code, Colors.cyan),
              _buildQualityCard('Performance', _performanceScore, Icons.speed, Colors.green),
              _buildQualityCard('Security', _securityScore, Icons.security, Colors.red),
              _buildQualityCard('Usability', _usabilityScore, Icons.people, Colors.orange),
              _buildQualityCard('Reliability', _reliabilityScore, Icons.verified, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityCard(String title, double value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text('${value.toStringAsFixed(1)}%', style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white70)),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey.shade800,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildTestsTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTestStat('Total', '$_totalTests', Colors.blue),
              _buildTestStat('Passed', '$_passedTests', Colors.green),
              _buildTestStat('Failed', '$_failedTests', Colors.red),
              _buildTestStat('Coverage', '${_testCoverage.toStringAsFixed(1)}%', Colors.orange),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _testResults.length,
            itemBuilder: (ctx, i) {
              final test = _testResults[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ExpansionTile(
                  leading: Icon(
                    test.passRate >= 90 ? Icons.check_circle : test.passRate >= 70 ? Icons.warning : Icons.error,
                    color: test.passRate >= 90 ? Colors.green : test.passRate >= 70 ? Colors.orange : Colors.red,
                  ),
                  title: Text(test.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Passed: ${test.passed} | Failed: ${test.failed} | Rate: ${test.passRate}%', style: const TextStyle(color: Colors.grey)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: test.passRate / 100,
                            backgroundColor: Colors.grey.shade800,
                            color: test.passRate >= 90 ? Colors.green : test.passRate >= 70 ? Colors.orange : Colors.red,
                          ),
                          const SizedBox(height: 8),
                          Text('Last run: ${_formatDate(test.lastRun)}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTestStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildPerformanceTab() {
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
                const Text('Response Times', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._responseTimes.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value} ms', style: const TextStyle(color: Colors.cyan)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 500,
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
            child: Column(
              children: [
                const Text('Error Rates (%)', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._errorRates.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value}%', style: const TextStyle(color: Colors.red)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 5,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.red,
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
                const Text('Performance Metrics', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._performanceMetrics.map((metric) => ListTile(
                  leading: Icon(Icons.speed, color: metric.color),
                  title: Text(metric.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Avg: ${metric.average}${metric.unit} | Peak: ${metric.peak}${metric.unit} | Min: ${metric.min}${metric.unit}', style: const TextStyle(color: Colors.grey)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
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
              const Text('Compliance Score', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _complianceScore / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.white,
                    ),
                  ),
                  Text('${_complianceScore.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              if (_nonCompliantItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text('Non-Compliant Items:', style: TextStyle(color: Colors.red)),
                      ..._nonCompliantItems.map((item) => Text('• $item', style: const TextStyle(color: Colors.white70))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _complianceItems.length,
            itemBuilder: (ctx, i) {
              final item = _complianceItems[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(item.icon, color: item.color),
                  title: Text(item.name, style: const TextStyle(color: Colors.white)),
                  subtitle: LinearProgressIndicator(
                    value: item.score / 100,
                    backgroundColor: Colors.grey.shade800,
                    color: item.color,
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.status == 'Compliant' ? Colors.green.withOpacity(0.2) :
                             item.status == 'Partial' ? Colors.orange.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(item.status, style: TextStyle(color: item.status == 'Compliant' ? Colors.green : Colors.orange)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

class TestResult {
  final String name;
  final int total;
  final int passed;
  final int failed;
  final double passRate;
  final DateTime lastRun;

  TestResult(this.name, this.total, this.passed, this.failed, this.passRate, this.lastRun);
}

class PerformanceMetric {
  final String name;
  final double average;
  final double min;
  final double peak;
  final String unit;
  final Color color;

  PerformanceMetric(this.name, this.average, this.min, this.peak, this.unit, this.color);
}

class ComplianceItem {
  final String name;
  final double score;
  final String status;
  final IconData icon;
  final Color color;

  ComplianceItem(this.name, this.score, this.status, this.icon, this.color);
}
