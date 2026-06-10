import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ResourcesCenter extends StatefulWidget {
  const ResourcesCenter({super.key});

  @override
  State<ResourcesCenter> createState() => _ResourcesCenterState();
}

class _ResourcesCenterState extends State<ResourcesCenter> {
  int _selectedTab = 0;
  
  // System Resources
  double _cpuUsage = 0.0;
  double _gpuUsage = 0.0;
  double _memoryUsage = 0.0;
  double _diskUsage = 0.0;
  double _batteryLevel = 0.0;
  double _temperature = 0.0;
  
  // Network Resources
  double _uploadSpeed = 0.0;
  double _downloadSpeed = 0.0;
  double _pingLatency = 0.0;
  int _activeConnections = 0;
  
  // Process Management
  List<ProcessInfo> _processes = [];
  List<ProcessInfo> _topProcesses = [];
  
  // Resource History
  List<ResourceHistory> _history = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initHistory();
    _loadProcesses();
    _startMonitoring();
  }

  void _initHistory() {
    for (int i = 0; i < 60; i++) {
      _history.add(ResourceHistory(
        timestamp: DateTime.now().subtract(Duration(seconds: 60 - i)),
        cpu: 0,
        memory: 0,
        network: 0,
      ));
    }
  }

  void _loadProcesses() {
    _processes = [
      ProcessInfo('Zion OS', 1, 2, 45, 128),
      ProcessInfo('SI Agent', 2, 5, 28, 256),
      ProcessInfo('Terminal', 3, 1, 12, 64),
      ProcessInfo('Network Monitor', 4, 3, 8, 96),
      ProcessInfo('Security Center', 5, 4, 22, 192),
      ProcessInfo('File Manager', 6, 1, 6, 48),
      ProcessInfo('Web Browser', 7, 8, 35, 512),
      ProcessInfo('System Services', 8, 6, 15, 128),
    ];
    _updateTopProcesses();
  }

  void _updateTopProcesses() {
    _topProcesses = List.from(_processes)
      ..sort((a, b) => b.cpuUsage.compareTo(a.cpuUsage));
    _topProcesses = _topProcesses.take(5).toList();
  }

  void _startMonitoring() {
    final random = Random();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _cpuUsage = 20 + random.nextDouble() * 60;
        _gpuUsage = 15 + random.nextDouble() * 50;
        _memoryUsage = 40 + random.nextDouble() * 40;
        _diskUsage = 55 + random.nextDouble() * 30;
        _batteryLevel = 70 - random.nextDouble() * 20;
        _temperature = 35 + random.nextDouble() * 15;
        _uploadSpeed = 5 + random.nextDouble() * 20;
        _downloadSpeed = 20 + random.nextDouble() * 80;
        _pingLatency = 10 + random.nextDouble() * 50;
        _activeConnections = 10 + random.nextInt(40);
        
        _history.add(ResourceHistory(
          timestamp: DateTime.now(),
          cpu: _cpuUsage,
          memory: _memoryUsage,
          network: _downloadSpeed,
        ));
        if (_history.length > 60) _history.removeAt(0);
        
        for (var process in _processes) {
          process.cpuUsage = (process.cpuUsage + (random.nextDouble() - 0.5) * 5).clamp(0.0, 100.0);
          process.memoryUsage = (process.memoryUsage + (random.nextInt(20) - 10)).clamp(0, 1024);
        }
        _updateTopProcesses();
      });
    });
  }

  void _killProcess(ProcessInfo process) {
    setState(() {
      _processes.remove(process);
      _updateTopProcesses();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${process.name} terminated')),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Resources Center'),
        backgroundColor: Colors.green.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.speed), text: 'System'),
            Tab(icon: Icon(Icons.network_check), text: 'Network'),
            Tab(icon: Icon(Icons.code), text: 'Processes'),
            Tab(icon: Icon(Icons.show_chart), text: 'History'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildSystemTab(),
          _buildNetworkTab(),
          _buildProcessesTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildSystemTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildResourceCard('CPU Usage', _cpuUsage, Icons.memory, Colors.cyan, 100),
          _buildResourceCard('GPU Usage', _gpuUsage, Icons.graphic_eq, Colors.purple, 100),
          _buildResourceCard('Memory Usage', _memoryUsage, Icons.storage, Colors.green, 100),
          _buildResourceCard('Disk Usage', _diskUsage, Icons.hard_drive, Colors.orange, 100),
          _buildResourceCard('Battery', _batteryLevel, Icons.battery_std, Colors.yellow, 100),
          _buildResourceCard('Temperature', _temperature, Icons.thermostat, Colors.red, 80),
        ],
      ),
    );
  }

  Widget _buildResourceCard(String title, double value, IconData icon, Color color, double max) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Text('${value.toStringAsFixed(1)}${title == 'Temperature' ? '°C' : '%'}', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / max,
            backgroundColor: Colors.grey.shade800,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkTab() {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNetworkStat('Download', '${_downloadSpeed.toStringAsFixed(1)} Mbps', Icons.arrow_downward, Colors.green),
                _buildNetworkStat('Upload', '${_uploadSpeed.toStringAsFixed(1)} Mbps', Icons.arrow_upward, Colors.blue),
                _buildNetworkStat('Ping', '${_pingLatency.toStringAsFixed(0)} ms', Icons.speed, Colors.orange),
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
                const Text('Active Connections', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Text('$_activeConnections', style: const TextStyle(color: Colors.cyan, fontSize: 48, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildProcessesTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top CPU Processes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Divider(),
              ..._topProcesses.map((process) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: Text('${process.pid}', style: const TextStyle(color: Colors.blue)),
                ),
                title: Text(process.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text('PID: ${process.pid} • Threads: ${process.threads}', style: const TextStyle(color: Colors.grey)),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${process.cpuUsage.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.cyan)),
                    Text('${process.memoryUsage} MB', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                onTap: () => _showProcessDetails(process),
              )),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _processes.length,
            itemBuilder: (ctx, i) {
              final process = _processes[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(process.name, style: const TextStyle(color: Colors.white)),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: process.cpuUsage / 100,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: Text('${process.cpuUsage.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop, color: Colors.red),
                      onPressed: () => _killProcess(process),
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

  void _showProcessDetails(ProcessInfo process) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(process.name),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PID: ${process.pid}', style: const TextStyle(color: Colors.white)),
            Text('Threads: ${process.threads}', style: const TextStyle(color: Colors.white)),
            Text('CPU Usage: ${process.cpuUsage.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white)),
            Text('Memory: ${process.memoryUsage} MB', style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final maxCpu = _history.map((h) => h.cpu).reduce((a, b) => a > b ? a : b);
    final maxMemory = _history.map((h) => h.memory).reduce((a, b) => a > b ? a : b);
    final maxNetwork = _history.map((h) => h.network).reduce((a, b) => a > b ? a : b);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CPU Usage History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _history.length,
                    itemBuilder: (ctx, i) {
                      final item = _history[i];
                      final height = (item.cpu / maxCpu) * 100;
                      return Container(
                        width: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        height: height,
                        color: Colors.cyan,
                      );
                    },
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Memory Usage History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _history.length,
                    itemBuilder: (ctx, i) {
                      final item = _history[i];
                      final height = (item.memory / maxMemory) * 100;
                      return Container(
                        width: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        height: height,
                        color: Colors.green,
                      );
                    },
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Network Usage History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _history.length,
                    itemBuilder: (ctx, i) {
                      final item = _history[i];
                      final height = (item.network / maxNetwork) * 100;
                      return Container(
                        width: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        height: height,
                        color: Colors.orange,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProcessInfo {
  final String name;
  final int pid;
  final int threads;
  double cpuUsage;
  int memoryUsage;

  ProcessInfo(this.name, this.pid, this.threads, this.cpuUsage, this.memoryUsage);
}

class ResourceHistory {
  final DateTime timestamp;
  final double cpu;
  final double memory;
  final double network;

  ResourceHistory({
    required this.timestamp,
    required this.cpu,
    required this.memory,
    required this.network,
  });
}
