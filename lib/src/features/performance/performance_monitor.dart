import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class PerformanceMonitor extends StatefulWidget {
  const PerformanceMonitor({super.key});

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  int _selectedMetric = 0;
  
  // مقاييس الأداء
  double _cpuUsage = 0.0;
  double _cpuTemp = 0.0;
  double _gpuUsage = 0.0;
  double _memoryUsage = 0.0;
  double _diskIO = 0.0;
  double _networkIO = 0.0;
  double _batteryTemp = 0.0;
  double _fps = 0.0;
  
  // بيانات الرسم البياني
  List<FlSpot> _cpuSpots = [];
  List<FlSpot> _memorySpots = [];
  List<FlSpot> _networkSpots = [];
  List<FlSpot> _temperatureSpots = [];
  
  // إحصائيات
  double _avgCpu = 0;
  double _peakCpu = 0;
  double _avgMemory = 0;
  double _peakMemory = 0;
  
  Timer? _monitorTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initCharts();
    _startMonitoring();
  }

  void _initCharts() {
    for (int i = 0; i < 30; i++) {
      _cpuSpots.add(FlSpot(i.toDouble(), 0));
      _memorySpots.add(FlSpot(i.toDouble(), 0));
      _networkSpots.add(FlSpot(i.toDouble(), 0));
      _temperatureSpots.add(FlSpot(i.toDouble(), 0));
    }
  }

  void _startMonitoring() {
    _monitorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateMetrics();
      _updateCharts();
      _calculateStats();
      if (mounted) setState(() {});
    });
  }

  void _updateMetrics() {
    _cpuUsage = 15 + _random.nextDouble() * 70;
    _cpuTemp = 35 + _cpuUsage * 0.4;
    _gpuUsage = 10 + _random.nextDouble() * 60;
    _memoryUsage = 25 + _random.nextDouble() * 55;
    _diskIO = 20 + _random.nextDouble() * 80;
    _networkIO = 10 + _random.nextDouble() * 90;
    _batteryTemp = 30 + _random.nextDouble() * 15;
    _fps = 30 + _random.nextDouble() * 30;
  }

  void _updateCharts() {
    // تحديث CPU chart
    _cpuSpots.removeAt(0);
    _cpuSpots.add(FlSpot(29, _cpuUsage));
    for (int i = 0; i < _cpuSpots.length; i++) {
      _cpuSpots[i] = FlSpot(i.toDouble(), _cpuSpots[i].y);
    }
    
    // تحديث Memory chart
    _memorySpots.removeAt(0);
    _memorySpots.add(FlSpot(29, _memoryUsage));
    for (int i = 0; i < _memorySpots.length; i++) {
      _memorySpots[i] = FlSpot(i.toDouble(), _memorySpots[i].y);
    }
    
    // تحديث Network chart
    _networkSpots.removeAt(0);
    _networkSpots.add(FlSpot(29, _networkIO));
    for (int i = 0; i < _networkSpots.length; i++) {
      _networkSpots[i] = FlSpot(i.toDouble(), _networkSpots[i].y);
    }
    
    // تحديث Temperature chart
    _temperatureSpots.removeAt(0);
    _temperatureSpots.add(FlSpot(29, _cpuTemp));
    for (int i = 0; i < _temperatureSpots.length; i++) {
      _temperatureSpots[i] = FlSpot(i.toDouble(), _temperatureSpots[i].y);
    }
  }

  void _calculateStats() {
    _avgCpu = _cpuSpots.map((s) => s.y).reduce((a, b) => a + b) / _cpuSpots.length;
    _peakCpu = _cpuSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    _avgMemory = _memorySpots.map((s) => s.y).reduce((a, b) => a + b) / _memorySpots.length;
    _peakMemory = _memorySpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Performance Monitor'),
        backgroundColor: Colors.teal.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildMetricsGrid()),
          SliverToBoxAdapter(child: _buildChartsSection()),
          SliverToBoxAdapter(child: _buildStatsCard()),
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
          _buildMetricCard('RAM', '${_memoryUsage.toStringAsFixed(1)}%', Icons.storage, Colors.green, _memoryUsage / 100),
          _buildMetricCard('FPS', '${_fps.toStringAsFixed(0)}', Icons.speed, Colors.orange, _fps / 60),
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
          const Text('Real-time Performance Charts', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildChart('CPU Usage', _cpuSpots, Colors.cyan, 0, 100),
          const SizedBox(height: 24),
          _buildChart('Memory Usage', _memorySpots, Colors.green, 0, 100),
          const SizedBox(height: 24),
          _buildChart('Network I/O', _networkSpots, Colors.orange, 0, 100),
          const SizedBox(height: 24),
          _buildChart('Temperature', _temperatureSpots, Colors.red, 20, 80),
        ],
      ),
    );
  }

  Widget _buildChart(String title, List<FlSpot> spots, Color color, double minY, double maxY) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontSize: 14)),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade800)),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minY: minY,
              maxY: maxY,
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

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Performance Statistics', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem('Avg CPU', '${_avgCpu.toStringAsFixed(1)}%', Colors.cyan)),
              Expanded(child: _buildStatItem('Peak CPU', '${_peakCpu.toStringAsFixed(1)}%', Colors.red)),
              Expanded(child: _buildStatItem('Avg RAM', '${_avgMemory.toStringAsFixed(1)}%', Colors.green)),
              Expanded(child: _buildStatItem('Peak RAM', '${_peakMemory.toStringAsFixed(1)}%', Colors.orange)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.thermostat, color: Colors.red),
                const SizedBox(width: 8),
                Text('CPU Temp: ${_cpuTemp.toStringAsFixed(1)}°C', style: const TextStyle(color: Colors.white)),
                const Spacer(),
                const Icon(Icons.storage, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Disk I/O: ${_diskIO.toStringAsFixed(1)} MB/s', style: const TextStyle(color: Colors.white)),
                const Spacer(),
                const Icon(Icons.sensors, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Battery: ${_batteryTemp.toStringAsFixed(1)}°C', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
