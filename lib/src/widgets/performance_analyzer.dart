import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class PerformanceAnalyzer extends StatefulWidget {
  const PerformanceAnalyzer({super.key});

  @override
  State<PerformanceAnalyzer> createState() => _PerformanceAnalyzerState();
}

class _PerformanceAnalyzerState extends State<PerformanceAnalyzer> {
  // مقاييس الأداء
  double _cpuUsage = 0.0;
  double _memoryUsage = 0.0;
  double _networkUsage = 0.0;
  double _diskUsage = 0.0;
  double _batteryLevel = 0.0;
  double _temperature = 0.0;
  
  // مؤشرات استراتيجية
  double _strategicEfficiency = 0.0;
  double _responseTime = 0.0;
  double _throughput = 0.0;
  double _resourceUtilization = 0.0;
  double _systemHealth = 0.0;
  
  // تحليل الشبكة المتداخلة
  Map<String, double> _crossImpactMatrix = {};
  List<Map<String, dynamic>> _correlations = [];
  
  Timer? _updateTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initCrossImpactMatrix();
    _startMonitoring();
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
      'Disk → CPU': 0.50,
      'Disk → Memory': 0.45,
      'Disk → Network': 0.40,
    };
  }

  void _startMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateMetrics();
      _calculateStrategicMetrics();
      _updateCorrelations();
      if (mounted) setState(() {});
    });
  }

  void _updateMetrics() {
    // محاكاة قراءات حية
    _cpuUsage = 15 + _random.nextDouble() * 70;
    _memoryUsage = 30 + _random.nextDouble() * 50;
    _networkUsage = 5 + _random.nextDouble() * 40;
    _diskUsage = 20 + _random.nextDouble() * 60;
    _batteryLevel = 60 - _random.nextDouble() * 30;
    _temperature = 35 + _random.nextDouble() * 15;
  }

  void _calculateStrategicMetrics() {
    // الكفاءة الاستراتيجية = (1 - متوسط الاستخدام) × (1 - درجة الحرارة/100)
    final avgUsage = (_cpuUsage + _memoryUsage + _diskUsage) / 300;
    _strategicEfficiency = (1 - avgUsage) * (1 - (_temperature / 100)).clamp(0.0, 1.0);
    
    // زمن الاستجابة (معكوس الاستخدام)
    _responseTime = (50 + _cpuUsage * 2).clamp(10.0, 200.0);
    
    // الإنتاجية (معكوس زمن الاستجابة)
    _throughput = (1000 / _responseTime).clamp(5.0, 100.0);
    
    // استخدام الموارد
    _resourceUtilization = (_cpuUsage + _memoryUsage + _networkUsage) / 300;
    
    // صحة النظام
    _systemHealth = (100 - _cpuUsage * 0.3 - _memoryUsage * 0.2 - _temperature * 0.5).clamp(0.0, 100.0);
  }

  void _updateCorrelations() {
    _correlations = [
      {'factor': 'CPU → Memory', 'value': _cpuUsage * _memoryUsage / 1000, 'impact': _crossImpactMatrix['CPU → Memory'] ?? 0},
      {'factor': 'Memory → Network', 'value': _memoryUsage * _networkUsage / 1000, 'impact': _crossImpactMatrix['Memory → Network'] ?? 0},
      {'factor': 'Network → CPU', 'value': _networkUsage * _cpuUsage / 1000, 'impact': _crossImpactMatrix['Network → CPU'] ?? 0},
      {'factor': 'System Load', 'value': (_cpuUsage + _memoryUsage) / 2, 'impact': 0.85},
      {'factor': 'Thermal Impact', 'value': _temperature, 'impact': 0.75},
    ];
  }

  Color _getPerformanceColor(double value) {
    if (value < 30) return Colors.green;
    if (value < 70) return Colors.orange;
    return Colors.red;
  }

  String _formatValue(double value, String unit) {
    if (unit == '%') return '${value.toStringAsFixed(1)}%';
    if (unit == 'ms') return '${value.toStringAsFixed(0)} ms';
    if (unit == 'req/s') return '${value.toStringAsFixed(1)} req/s';
    return value.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان
          Row(
            children: [
              const Icon(Icons.analytics, color: Colors.cyan, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Strategic Performance Analysis',
                style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _systemHealth > 70 ? Colors.green : (_systemHealth > 40 ? Colors.orange : Colors.red),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.cyan, height: 8),
          
          // مقاييس النظام الأساسية
          Row(
            children: [
              _buildMetric('CPU', _cpuUsage, '%', Colors.cyan),
              _buildMetric('RAM', _memoryUsage, '%', Colors.green),
              _buildMetric('NET', _networkUsage, '%', Colors.orange),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // مقاييس الأداء الاستراتيجي
          Row(
            children: [
              _buildMetric('Efficiency', _strategicEfficiency * 100, '%', Colors.purple),
              _buildMetric('Response', _responseTime, 'ms', Colors.blue),
              _buildMetric('Throughput', _throughput, 'req/s', Colors.teal),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // مصفوفة التأثير المتداخل (Cross-Impact Matrix)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cross-Impact Matrix',
                  style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ..._correlations.take(3).map((cor) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '${cor['factor']}:',
                        style: const TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (cor['value'] as double) / 100,
                          backgroundColor: Colors.grey.shade800,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${((cor['impact'] as double) * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.amber, fontSize: 9),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // حالة النظام
          Row(
            children: [
              const Icon(Icons.thermostat, color: Colors.red, size: 12),
              const SizedBox(width: 4),
              Text(
                '${_temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.battery_std, color: Colors.yellow, size: 12),
              const SizedBox(width: 4),
              Text(
                '${_batteryLevel.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.health_and_safety, color: Colors.green, size: 12),
              const SizedBox(width: 4),
              Text(
                '${_systemHealth.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, double value, String unit, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            _formatValue(value, unit),
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 9),
          ),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey.shade800,
            color: _getPerformanceColor(value),
          ),
        ],
      ),
    );
  }
}
