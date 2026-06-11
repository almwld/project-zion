import 'package:flutter/material.dart';
import 'spider_chart.dart';
import 'dart:async';
import 'dart:math';

class PerformanceAnalyzer extends StatefulWidget {
  const PerformanceAnalyzer({super.key});

  @override
  State<PerformanceAnalyzer> createState() => _PerformanceAnalyzerState();
}

class _PerformanceAnalyzerState extends State<PerformanceAnalyzer> {
  double _overallScore = 0.0;
  Timer? _updateTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startUpdates();
  }

  void _startUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _overallScore = 0.4 + _random.nextDouble() * 0.5;
      });
    });
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
          Row(
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
                  color: _overallScore > 0.7 ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Score: ${(_overallScore * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: _overallScore > 0.7 ? Colors.green : Colors.orange, fontSize: 10),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.cyan, height: 8),
          
          // Spider Chart (الرسم العنكبوتي)
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: const SpiderChart(),
            ),
          ),
          
          const Divider(color: Colors.cyan, height: 8),
          
          // Cross-Impact Matrix Summary
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
                  'Cross-Impact Analysis',
                  style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                _buildImpactRow('CPU → Performance', 0.72),
                _buildImpactRow('Memory → Speed', 0.68),
                _buildImpactRow('Network → Latency', 0.55),
                _buildImpactRow('Thermal → Stability', 0.81),
              ],
            ),
          ),
          
          const SizedBox(height: 6),
          
          // System Status
          Row(
            children: [
              const Icon(Icons.thermostat, color: Colors.red, size: 12),
              const SizedBox(width: 4),
              const Text('42°C', style: TextStyle(color: Colors.white70, fontSize: 10)),
              const SizedBox(width: 12),
              const Icon(Icons.battery_std, color: Colors.yellow, size: 12),
              const SizedBox(width: 4),
              const Text('73%', style: TextStyle(color: Colors.white70, fontSize: 10)),
              const SizedBox(width: 12),
              Icon(Icons.health_and_safety, color: _overallScore > 0.7 ? Colors.green : Colors.orange, size: 12),
              const SizedBox(width: 4),
              Text(
                '${(_overallScore * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: _overallScore > 0.7 ? Colors.green : Colors.orange, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 8))),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade800,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 4),
          Text('${(value * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.amber, fontSize: 8)),
        ],
      ),
    );
  }
}
