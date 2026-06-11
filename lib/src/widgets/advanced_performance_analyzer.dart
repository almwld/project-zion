import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class AdvancedPerformanceAnalyzer extends StatefulWidget {
  const AdvancedPerformanceAnalyzer({super.key});

  @override
  State<AdvancedPerformanceAnalyzer> createState() => _AdvancedPerformanceAnalyzerState();
}

class _AdvancedPerformanceAnalyzerState extends State<AdvancedPerformanceAnalyzer> {
  // مقاييس الأداء المتقدمة
  double _cpuUsage = 0.0;
  double _cpuTemp = 0.0;
  double _gpuUsage = 0.0;
  double _memoryUsage = 0.0;
  double _swapUsage = 0.0;
  double _networkRx = 0.0;
  double _networkTx = 0.0;
  double _diskRead = 0.0;
  double _diskWrite = 0.0;
  double _batteryLevel = 0.0;
  double _batteryHealth = 0.0;
  double _temperature = 0.0;
  
  // مؤشرات استراتيجية متقدمة
  double _strategicEfficiency = 0.0;
  double _operationalEffectiveness = 0.0;
  double _predictiveScore = 0.0;
  double _anomalyScore = 0.0;
  double _resourceOptimization = 0.0;
  double _threatIndex = 0.0;
  
  // بيانات الرسم البياني
  List<FlSpot> _cpuHistory = [];
  List<FlSpot> _memoryHistory = [];
  List<FlSpot> _networkHistory = [];
  List<FlSpot> _temperatureHistory = [];
  
  // تحليلات متقدمة
  List<Map<String, dynamic>> _bottlenecks = [];
  List<Map<String, dynamic>> _predictions = [];
  Map<String, double> _crossImpactMatrix = {};
  List<Map<String, dynamic>> _anomalies = [];
  
  Timer? _updateTimer;
  final Random _random = Random();
  int _historyIndex = 0;

  @override
  void initState() {
    super.initState();
    _initHistory();
    _initCrossImpactMatrix();
    _startAdvancedMonitoring();
  }

  void _initHistory() {
    for (int i = 0; i < 30; i++) {
      _cpuHistory.add(FlSpot(i.toDouble(), 0));
      _memoryHistory.add(FlSpot(i.toDouble(), 0));
      _networkHistory.add(FlSpot(i.toDouble(), 0));
      _temperatureHistory.add(FlSpot(i.toDouble(), 0));
    }
  }

  void _initCrossImpactMatrix() {
    _crossImpactMatrix = {
      'CPU → Memory': 0.65,
      'CPU → Network': 0.45,
      'CPU → Disk': 0.55,
      'Memory → CPU': 0.70,
      'Memory → Network': 0.50,
      'Memory → Disk': 0.60,
      'Network → CPU': 0.40,
      'Network → Memory': 0.55,
      'Network → Disk': 0.35,
      'Thermal → CPU': 0.80,
      'Battery → Performance': 0.60,
    };
  }

  void _startAdvancedMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateAdvancedMetrics();
      _calculateStrategicMetrics();
      _detectBottlenecks();
      _generatePredictions();
      _detectAnomalies();
      _updateHistory();
      if (mounted) setState(() {});
    });
  }

  void _updateAdvancedMetrics() {
    _cpuUsage = 15 + _random.nextDouble() * 70;
    _cpuTemp = 35 + _cpuUsage * 0.4;
    _gpuUsage = 10 + _random.nextDouble() * 60;
    _memoryUsage = 30 + _random.nextDouble() * 50;
    _swapUsage = _random.nextDouble() * 20;
    _networkRx = 10 + _random.nextDouble() * 90;
    _networkTx = 5 + _random.nextDouble() * 50;
    _diskRead = 20 + _random.nextDouble() * 80;
    _diskWrite = 15 + _random.nextDouble() * 60;
    _batteryLevel = 60 - _random.nextDouble() * 30;
    _batteryHealth = 80 + _random.nextDouble() * 15;
    _temperature = 35 + _random.nextDouble() * 20;
  }

  void _calculateStrategicMetrics() {
    final avgUsage = (_cpuUsage + _memoryUsage + _gpuUsage) / 300;
    final tempFactor = (1 - (_temperature - 35) / 30).clamp(0.0, 1.0);
    
    _strategicEfficiency = (1 - avgUsage) * tempFactor;
    _operationalEffectiveness = ((100 - _cpuUsage) + (100 - _memoryUsage) + _batteryHealth) / 300;
    _predictiveScore = _strategicEfficiency * 0.6 + _operationalEffectiveness * 0.4;
    _anomalyScore = _calculateAnomalyScore();
    _resourceOptimization = (1 - (_swapUsage / 20)).clamp(0.0, 1.0);
    _threatIndex = (_anomalyScore * 0.7 + (1 - _strategicEfficiency) * 0.3).clamp(0.0, 1.0);
  }

  double _calculateAnomalyScore() {
    // كشف الأنماط غير الطبيعية
    double score = 0;
    if (_cpuUsage > 85) score += 0.3;
    if (_memoryUsage > 90) score += 0.2;
    if (_temperature > 50) score += 0.3;
    if (_networkRx > 80) score += 0.2;
    return score;
  }

  void _detectBottlenecks() {
    _bottlenecks.clear();
    if (_cpuUsage > 80) {
      _bottlenecks.add({'resource': 'CPU', 'usage': _cpuUsage, 'impact': 'High', 'solution': 'Reduce background processes'});
    }
    if (_memoryUsage > 85) {
      _bottlenecks.add({'resource': 'Memory', 'usage': _memoryUsage, 'impact': 'High', 'solution': 'Close unused applications'});
    }
    if (_diskRead > 70 || _diskWrite > 70) {
      _bottlenecks.add({'resource': 'Disk I/O', 'usage': (_diskRead + _diskWrite) / 2, 'impact': 'Medium', 'solution': 'Check disk activity'});
    }
    if (_temperature > 45) {
      _bottlenecks.add({'resource': 'Thermal', 'usage': _temperature, 'impact': 'Critical', 'solution': 'Reduce workload'});
    }
  }

  void _generatePredictions() {
    _predictions.clear();
    _predictions.add({
      'metric': 'CPU Load',
      'current': _cpuUsage,
      'predicted': (_cpuUsage + _random.nextDouble() * 10 - 5).clamp(0.0, 100.0),
      'trend': _random.nextDouble() > 0.5 ? 'up' : 'down',
      'confidence': 0.7 + _random.nextDouble() * 0.25,
    });
    _predictions.add({
      'metric': 'Memory Usage',
      'current': _memoryUsage,
      'predicted': (_memoryUsage + _random.nextDouble() * 8 - 4).clamp(0.0, 100.0),
      'trend': _random.nextDouble() > 0.5 ? 'up' : 'down',
      'confidence': 0.75 + _random.nextDouble() * 0.2,
    });
    _predictions.add({
      'metric': 'Temperature',
      'current': _temperature,
      'predicted': (_temperature + _random.nextDouble() * 3 - 1.5).clamp(25.0, 70.0),
      'trend': _cpuUsage > 70 ? 'up' : 'stable',
      'confidence': 0.8 + _random.nextDouble() * 0.15,
    });
  }

  void _detectAnomalies() {
    _anomalies.clear();
    if (_cpuUsage > 90) {
      _anomalies.add({'type': 'CPU Spike', 'value': _cpuUsage, 'severity': 'High', 'timestamp': DateTime.now()});
    }
    if (_memoryUsage > 95) {
      _anomalies.add({'type': 'Memory Leak', 'value': _memoryUsage, 'severity': 'Critical', 'timestamp': DateTime.now()});
    }
    if (_temperature > 55) {
      _anomalies.add({'type': 'Overheating', 'value': _temperature, 'severity': 'High', 'timestamp': DateTime.now()});
    }
    if (_networkRx > 95 || _networkTx > 95) {
      _anomalies.add({'type': 'Network Saturation', 'value': (_networkRx + _networkTx) / 2, 'severity': 'Medium', 'timestamp': DateTime.now()});
    }
  }

  void _updateHistory() {
    _cpuHistory.removeAt(0);
    _cpuHistory.add(FlSpot(29, _cpuUsage));
    for (int i = 0; i < _cpuHistory.length; i++) {
      _cpuHistory[i] = FlSpot(i.toDouble(), _cpuHistory[i].y);
    }
    
    _memoryHistory.removeAt(0);
    _memoryHistory.add(FlSpot(29, _memoryUsage));
    for (int i = 0; i < _memoryHistory.length; i++) {
      _memoryHistory[i] = FlSpot(i.toDouble(), _memoryHistory[i].y);
    }
    
    _networkHistory.removeAt(0);
    _networkHistory.add(FlSpot(29, (_networkRx + _networkTx) / 2));
    for (int i = 0; i < _networkHistory.length; i++) {
      _networkHistory[i] = FlSpot(i.toDouble(), _networkHistory[i].y);
    }
    
    _temperatureHistory.removeAt(0);
    _temperatureHistory.add(FlSpot(29, _temperature));
    for (int i = 0; i < _temperatureHistory.length; i++) {
      _temperatureHistory[i] = FlSpot(i.toDouble(), _temperatureHistory[i].y);
    }
  }

  Color _getStatusColor(double value, double warning, double critical) {
    if (value < warning) return Colors.green;
    if (value < critical) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),
          const Divider(color: Colors.cyan, height: 8),
          
          // Main Metrics Grid
          _buildMainMetrics(),
          const SizedBox(height: 8),
          
          // Performance Charts
          _buildPerformanceCharts(),
          const SizedBox(height: 8),
          
          // Cross-Impact Matrix
          _buildCrossImpactMatrix(),
          const SizedBox(height: 8),
          
          // Predictions & Anomalies
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPredictions()),
              const SizedBox(width: 8),
              Expanded(child: _buildAnomalies()),
            ],
          ),
          const SizedBox(height: 8),
          
          // Bottlenecks
          _buildBottlenecks(),
          const SizedBox(height: 8),
          
          // System Health Summary
          _buildHealthSummary(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.analytics, color: Colors.cyan, size: 18),
        const SizedBox(width: 8),
        const Text(
          'Strategic Performance Analysis',
          style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _predictiveScore > 0.7 ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Score: ${(_predictiveScore * 100).toStringAsFixed(0)}%',
            style: TextStyle(color: _predictiveScore > 0.7 ? Colors.green : Colors.orange, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildMainMetrics() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard('CPU', '${_cpuUsage.toStringAsFixed(1)}%', _cpuUsage, Icons.memory, Colors.cyan),
        _buildMetricCard('RAM', '${_memoryUsage.toStringAsFixed(1)}%', _memoryUsage, Icons.storage, Colors.green),
        _buildMetricCard('GPU', '${_gpuUsage.toStringAsFixed(1)}%', _gpuUsage, Icons.graphic_eq, Colors.purple),
        _buildMetricCard('Temp', '${_temperature.toStringAsFixed(1)}°C', _temperature, Icons.thermostat, Colors.red),
        _buildMetricCard('Battery', '${_batteryLevel.toStringAsFixed(0)}%', _batteryLevel, Icons.battery_std, Colors.yellow),
        _buildMetricCard('Threat', '${(_threatIndex * 100).toStringAsFixed(0)}%', _threatIndex * 100, Icons.warning, Colors.orange),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, double progress, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 8)),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey.shade800,
            color: _getStatusColor(progress, 70, 85),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCharts() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance History', style: TextStyle(color: Colors.white70, fontSize: 10)),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(spots: _cpuHistory, color: Colors.cyan, barWidth: 1.5, dotData: const FlDotData(show: false)),
                  LineChartBarData(spots: _memoryHistory, color: Colors.green, barWidth: 1.5, dotData: const FlDotData(show: false)),
                  LineChartBarData(spots: _temperatureHistory, color: Colors.red, barWidth: 1.5, dotData: const FlDotData(show: false)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossImpactMatrix() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cross-Impact Matrix', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ..._crossImpactMatrix.entries.take(4).map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(width: 80, child: Text(entry.key, style: const TextStyle(color: Colors.white70, fontSize: 8))),
                Expanded(
                  child: LinearProgressIndicator(
                    value: entry.value,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 4),
                Text('${(entry.value * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.amber, fontSize: 8)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPredictions() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Predictions', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ..._predictions.map((pred) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  pred['trend'] == 'up' ? Icons.trending_up : Icons.trending_down,
                  color: pred['trend'] == 'up' ? Colors.red : Colors.green,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(pred['metric'], style: const TextStyle(color: Colors.white70, fontSize: 8)),
                const Spacer(),
                Text('${(pred['predicted'] as double).toStringAsFixed(0)}${pred['metric'] == 'Temperature' ? '°C' : '%'}',
                  style: const TextStyle(color: Colors.blue, fontSize: 8)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAnomalies() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Anomalies', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          if (_anomalies.isEmpty)
            const Text('None detected', style: TextStyle(color: Colors.green, fontSize: 8))
          else
            ..._anomalies.map((anom) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.warning, color: anom['severity'] == 'Critical' ? Colors.red : Colors.orange, size: 10),
                  const SizedBox(width: 4),
                  Text(anom['type'], style: TextStyle(color: anom['severity'] == 'Critical' ? Colors.red : Colors.white70, fontSize: 8)),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildBottlenecks() {
    if (_bottlenecks.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bottlenecks Detected', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ..._bottlenecks.map((bn) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              '• ${bn['resource']}: ${bn['solution']}',
              style: TextStyle(color: Colors.white70, fontSize: 8),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildHealthSummary() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.cyan.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.health_and_safety, color: Colors.green, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: LinearProgressIndicator(
              value: _systemHealth / 100,
              backgroundColor: Colors.grey.shade800,
              color: _systemHealth > 70 ? Colors.green : (_systemHealth > 40 ? Colors.orange : Colors.red),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${_systemHealth.toStringAsFixed(0)}%',
            style: TextStyle(color: _systemHealth > 70 ? Colors.green : Colors.orange, fontSize: 10),
          ),
        ],
      ),
    );
  }

  double get _systemHealth => (100 - _cpuUsage * 0.3 - _memoryUsage * 0.2 - _temperature * 0.5).clamp(0.0, 100.0);
}
