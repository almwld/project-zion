import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class MonitoringCenter extends StatefulWidget {
  const MonitoringCenter({super.key});

  @override
  State<MonitoringCenter> createState() => _MonitoringCenterState();
}

class _MonitoringCenterState extends State<MonitoringCenter> {
  late Timer _refreshTimer;
  final Random _random = Random();
  
  // مقاييس النظام
  double _cpuUsage = 0.0;
  double _gpuUsage = 0.0;
  double _ramUsage = 0.0;
  int _diskRead = 0;
  int _diskWrite = 0;
  int _networkRx = 0;
  int _networkTx = 0;
  int _activeProcesses = 0;
  int _systemUptime = 0;
  double _systemLoad = 0.0;
  
  // بيانات الرسم البياني
  List<FlSpot> _cpuSpots = [];
  List<FlSpot> _ramSpots = [];
  List<FlSpot> _networkSpots = [];
  
  // سجل الأحداث
  List<SystemEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _initData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateMetrics();
    });
  }

  void _initData() {
    for (int i = 0; i < 20; i++) {
      _cpuSpots.add(FlSpot(i.toDouble(), 0));
      _ramSpots.add(FlSpot(i.toDouble(), 0));
      _networkSpots.add(FlSpot(i.toDouble(), 0));
    }
    
    _events = [
      SystemEvent('System Started', DateTime.now().subtract(const Duration(hours: 2)), 'info'),
      SystemEvent('Network Connected', DateTime.now().subtract(const Duration(hours: 1, minutes: 30)), 'success'),
      SystemEvent('High CPU Usage Detected', DateTime.now().subtract(const Duration(minutes: 45)), 'warning'),
      SystemEvent('Memory Optimization', DateTime.now().subtract(const Duration(minutes: 20)), 'info'),
    ];
  }

  void _updateMetrics() {
    setState(() {
      _cpuUsage = 20 + _random.nextDouble() * 60;
      _gpuUsage = 15 + _random.nextDouble() * 50;
      _ramUsage = 40 + _random.nextDouble() * 40;
      _diskRead = 50 + _random.nextInt(150);
      _diskWrite = 30 + _random.nextInt(100);
      _networkRx = 100 + _random.nextInt(500);
      _networkTx = 50 + _random.nextInt(300);
      _activeProcesses = 80 + _random.nextInt(40);
      _systemUptime += 2;
      _systemLoad = _cpuUsage / 100;
      
      // تحديث الرسوم البيانية
      _cpuSpots.removeAt(0);
      _cpuSpots.add(FlSpot(19, _cpuUsage));
      for (int i = 0; i < _cpuSpots.length; i++) {
        _cpuSpots[i] = FlSpot(i.toDouble(), _cpuSpots[i].y);
      }
      
      _ramSpots.removeAt(0);
      _ramSpots.add(FlSpot(19, _ramUsage));
      for (int i = 0; i < _ramSpots.length; i++) {
        _ramSpots[i] = FlSpot(i.toDouble(), _ramSpots[i].y);
      }
      
      _networkSpots.removeAt(0);
      _networkSpots.add(FlSpot(19, (_networkRx / 1000)));
      for (int i = 0; i < _networkSpots.length; i++) {
        _networkSpots[i] = FlSpot(i.toDouble(), _networkSpots[i].y);
      }
    });
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B/s';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB/s';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  String _formatUptime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours}h ${minutes}m ${secs}s';
  }

  Color _getLoadColor(double load) {
    if (load < 0.5) return Colors.green;
    if (load < 0.75) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Monitoring Center'),
        backgroundColor: Colors.lime.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildMetricsGrid()),
          SliverToBoxAdapter(child: _buildChartsSection()),
          SliverToBoxAdapter(child: _buildDiskNetworkCard()),
          SliverToBoxAdapter(child: _buildEventsCard()),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
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
          _buildMetricCard('CPU', '${_cpuUsage.toStringAsFixed(1)}%', Icons.memory, Colors.cyan, _cpuUsage / 100),
          _buildMetricCard('GPU', '${_gpuUsage.toStringAsFixed(1)}%', Icons.graphic_eq, Colors.purple, _gpuUsage / 100),
          _buildMetricCard('RAM', '${_ramUsage.toStringAsFixed(1)}%', Icons.storage, Colors.green, _ramUsage / 100),
          _buildMetricCard('Load', '${(_systemLoad * 100).toStringAsFixed(1)}%', Icons.speed, Colors.orange, _systemLoad),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, double progress) {
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
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade800,
            color: color,
          ),
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
          const Text('Real-time Charts', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildChart('CPU Usage', _cpuSpots, Colors.cyan),
          const SizedBox(height: 24),
          _buildChart('RAM Usage', _ramSpots, Colors.green),
          const SizedBox(height: 24),
          _buildChart('Network Traffic', _networkSpots, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildChart(String title, List<FlSpot> spots, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontSize: 14)),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiskNetworkCard() {
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
          const Text('Disk & Network', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard('Disk Read', _formatBytes(_diskRead), Icons.download, Colors.blue),
              ),
              Expanded(
                child: _buildDetailCard('Disk Write', _formatBytes(_diskWrite), Icons.upload, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard('Network RX', _formatBytes(_networkRx), Icons.arrow_downward, Colors.cyan),
              ),
              Expanded(
                child: _buildDetailCard('Network TX', _formatBytes(_networkTx), Icons.arrow_upward, Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildEventsCard() {
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
              Icon(Icons.history, color: Colors.lime),
              SizedBox(width: 8),
              Text('System Events', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ..._events.map((event) => ListTile(
            leading: Icon(
              event.type == 'success' ? Icons.check_circle :
              event.type == 'warning' ? Icons.warning :
              Icons.info,
              color: event.type == 'success' ? Colors.green :
                     event.type == 'warning' ? Colors.orange :
                     Colors.blue,
            ),
            title: Text(event.message, style: const TextStyle(color: Colors.white)),
            subtitle: Text(_formatTime(event.time), style: const TextStyle(color: Colors.grey)),
          )),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

class SystemEvent {
  final String message;
  final DateTime time;
  final String type;

  SystemEvent(this.message, this.time, this.type);
}
