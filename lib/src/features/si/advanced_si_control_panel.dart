import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class AdvancedSIControlPanel extends StatefulWidget {
  const AdvancedSIControlPanel({super.key});

  @override
  State<AdvancedSIControlPanel> createState() => _AdvancedSIControlPanelState();
}

class _AdvancedSIControlPanelState extends State<AdvancedSIControlPanel> with SingleTickerProviderStateMixin {
  bool _siActive = false;
  final List<AttackLog> _attackLogs = [];
  final List<NetworkTraffic> _trafficData = [];
  late Timer _simulationTimer;
  final Random _random = Random();

  // مقاييس SI
  double _learningProgress = 0.0;
  int _totalAttacks = 0;
  int _successfulAttacks = 0;
  int _failedAttacks = 0;
  double _aiConfidence = 0.0;
  int _activeThreats = 0;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_siActive) {
        _generateRandomAttack();
        _updateMetrics();
      }
      _generateTrafficData();
      setState(() {});
    });
  }

  void _generateRandomAttack() {
    final targets = ['192.168.1.1', '192.168.1.100', '10.0.0.1', '8.8.8.8'];
    final attackTypes = ['Port Scan', 'Brute Force', 'SQL Injection', 'DoS', 'MITM'];
    final success = _random.nextDouble() > 0.3;
    
    _attackLogs.insert(0, AttackLog(
      time: DateTime.now(),
      target: targets[_random.nextInt(targets.length)],
      attackType: attackTypes[_random.nextInt(attackTypes.length)],
      success: success,
      details: success ? 'Exploit successful' : 'Target protected',
    ));
    
    if (_attackLogs.length > 50) _attackLogs.removeLast();
    
    _totalAttacks++;
    if (success) _successfulAttacks++;
    else _failedAttacks++;
  }

  void _updateMetrics() {
    _learningProgress = (_learningProgress + 0.02).clamp(0.0, 1.0);
    _aiConfidence = 0.5 + (_random.nextDouble() * 0.4);
    _activeThreats = _random.nextInt(10);
  }

  void _generateTrafficData() {
    final now = DateTime.now();
    final packets = _random.nextInt(200) + 50;
    _trafficData.add(NetworkTraffic(time: now, packets: packets));
    if (_trafficData.length > 30) _trafficData.removeAt(0);
  }

  void _toggleSI() {
    setState(() {
      _siActive = !_siActive;
      if (_siActive) {
        _attackLogs.insert(0, AttackLog(
          time: DateTime.now(),
          target: 'System',
          attackType: 'SI Agent Activated',
          success: true,
          details: 'AI monitoring started',
        ));
      }
    });
  }

  @override
  void dispose() {
    _simulationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('SI Agent Control Panel'),
        backgroundColor: Colors.purple.shade900,
        actions: [
          Switch(
            value: _siActive,
            onChanged: (_) => _toggleSI(),
            activeColor: Colors.purple,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildMetricsCards()),
          SliverToBoxAdapter(child: _buildTrafficChart()),
          SliverToBoxAdapter(child: _buildLearningCard()),
          SliverToBoxAdapter(child: _buildAttackLogs()),
        ],
      ),
    );
  }

  Widget _buildMetricsCards() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildMetricCard('Total Attacks', '$_totalAttacks', Icons.flash_on, Colors.orange),
          _buildMetricCard('Success Rate', '${_totalAttacks > 0 ? ((_successfulAttacks / _totalAttacks) * 100).toStringAsFixed(1) : '0'}%', Icons.check_circle, Colors.green),
          _buildMetricCard('AI Confidence', '${(_aiConfidence * 100).toStringAsFixed(1)}%', Icons.psychology, Colors.purple),
          _buildMetricCard('Active Threats', '$_activeThreats', Icons.warning, Colors.red),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTrafficChart() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.area_chart, color: Colors.cyan),
              SizedBox(width: 8),
              Text('Network Traffic', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _trafficData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.packets.toDouble())).toList(),
                    isCurved: true,
                    color: Colors.cyan,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple),
              SizedBox(width: 8),
              Text('Reinforcement Learning Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: _learningProgress, color: Colors.purple),
          const SizedBox(height: 8),
          Text('${(_learningProgress * 100).toStringAsFixed(1)}% trained', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAttackLogs() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, color: Colors.green),
              SizedBox(width: 8),
              Text('Attack Log', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _attackLogs.length > 10 ? 10 : _attackLogs.length,
            itemBuilder: (ctx, i) {
              final log = _attackLogs[i];
              return ListTile(
                dense: true,
                leading: Icon(
                  log.success ? Icons.check_circle : Icons.error,
                  color: log.success ? Colors.green : Colors.red,
                  size: 20,
                ),
                title: Text('${log.attackType} on ${log.target}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                subtitle: Text('${_formatTime(log.time)} - ${log.details}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                trailing: Text(log.success ? 'SUCCESS' : 'FAILED', style: TextStyle(color: log.success ? Colors.green : Colors.red, fontSize: 11)),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}

class AttackLog {
  final DateTime time;
  final String target;
  final String attackType;
  final bool success;
  final String details;

  AttackLog({
    required this.time,
    required this.target,
    required this.attackType,
    required this.success,
    required this.details,
  });
}

class NetworkTraffic {
  final DateTime time;
  final int packets;

  NetworkTraffic({required this.time, required this.packets});
}
