import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class MaintenanceCenter extends StatefulWidget {
  const MaintenanceCenter({super.key});

  @override
  State<MaintenanceCenter> createState() => _MaintenanceCenterState();
}

class _MaintenanceCenterState extends State<MaintenanceCenter> {
  bool _isScanning = false;
  bool _isOptimizing = false;
  double _systemHealth = 85.0;
  int _memoryUsage = 0;
  int _storageUsage = 0;
  int _batteryHealth = 92;
  int _temperature = 38;
  List<MaintenanceTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadSystemStats();
    _loadMaintenanceTasks();
  }

  void _loadSystemStats() {
    _memoryUsage = 2048 + (DateTime.now().millisecondsSinceEpoch % 1024).toInt();
    _storageUsage = 32 + (DateTime.now().millisecondsSinceEpoch % 16).toInt();
  }

  void _loadMaintenanceTasks() {
    _tasks = [
      MaintenanceTask(
        id: '1',
        name: 'Clear System Cache',
        description: 'Remove temporary files and cache',
        icon: Icons.cached,
        color: Colors.orange,
        estimatedTime: 30,
        status: 'Pending',
      ),
      MaintenanceTask(
        id: '2',
        name: 'Optimize Memory',
        description: 'Free up RAM for better performance',
        icon: Icons.memory,
        color: Colors.blue,
        estimatedTime: 45,
        status: 'Pending',
      ),
      MaintenanceTask(
        id: '3',
        name: 'Defragment Storage',
        description: 'Optimize file system',
        icon: Icons.storage,
        color: Colors.green,
        estimatedTime: 120,
        status: 'Pending',
      ),
      MaintenanceTask(
        id: '4',
        name: 'Check for Updates',
        description: 'System and security updates',
        icon: Icons.update,
        color: Colors.purple,
        estimatedTime: 60,
        status: 'Pending',
      ),
      MaintenanceTask(
        id: '5',
        name: 'Repair Permissions',
        description: 'Fix file and app permissions',
        icon: Icons.security,
        color: Colors.red,
        estimatedTime: 90,
        status: 'Pending',
      ),
    ];
  }

  Future<void> _startSystemScan() async {
    setState(() {
      _isScanning = true;
      _systemHealth = 85;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isScanning = false;
      _systemHealth = 92;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System scan completed! Health improved to 92%')),
    );
  }

  Future<void> _runOptimization() async {
    setState(() {
      _isOptimizing = true;
    });

    await Future.delayed(const Duration(seconds: 4));

    setState(() {
      _isOptimizing = false;
      _memoryUsage = (2048 - (DateTime.now().millisecondsSinceEpoch % 512)).toInt();
      _storageUsage = (32 - (DateTime.now().millisecondsSinceEpoch % 8)).toInt();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System optimized! Memory and storage cleaned.')),
    );
  }

  Future<void> _runTask(MaintenanceTask task) async {
    setState(() {
      task.status = 'Running';
    });

    await Future.delayed(Duration(seconds: task.estimatedTime ~/ 10));

    setState(() {
      task.status = 'Completed';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${task.name} completed!')),
    );
  }

  Color _getHealthColor() {
    if (_systemHealth >= 80) return Colors.green;
    if (_systemHealth >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatMemory(int mb) {
    if (mb < 1024) return '$mb MB';
    return '${(mb / 1024).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Maintenance Center'),
        backgroundColor: Colors.purple.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHealthCard()),
          SliverToBoxAdapter(child: _buildStatsCard()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildTasksList()),
        ],
      ),
    );
  }

  Widget _buildHealthCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: Colors.white),
              SizedBox(width: 8),
              Text('System Health', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: _systemHealth / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade800,
                  color: _getHealthColor(),
                ),
              ),
              Column(
                children: [
                  Text('${_systemHealth.toStringAsFixed(0)}%', style: TextStyle(color: _getHealthColor(), fontSize: 32, fontWeight: FontWeight.bold)),
                  const Text('Overall', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isScanning ? null : _startSystemScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: _isScanning
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('SCAN SYSTEM'),
          ),
        ],
      ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Memory', _formatMemory(_memoryUsage), Icons.memory, Colors.blue),
          _buildStatItem('Storage', '${_storageUsage} GB', Icons.storage, Colors.green),
          _buildStatItem('Battery', '$_batteryHealth%', Icons.battery_full, Colors.yellow),
          _buildStatItem('Temp', '$_temperature°C', Icons.thermostat, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isOptimizing ? null : _runOptimization,
              icon: const Icon(Icons.speed),
              label: const Text('OPTIMIZE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.restart_alt),
              label: const Text('REBOOT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
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
          const Text('Maintenance Tasks', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._tasks.map((task) => ListTile(
            leading: Icon(task.icon, color: task.color),
            title: Text(task.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(task.description, style: const TextStyle(color: Colors.grey)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.status == 'Running')
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                if (task.status == 'Completed')
                  const Icon(Icons.check_circle, color: Colors.green),
                if (task.status == 'Pending')
                  ElevatedButton(
                    onPressed: () => _runTask(task),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.color,
                      minimumSize: const Size(80, 30),
                    ),
                    child: const Text('Run', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class MaintenanceTask {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int estimatedTime;
  String status;

  MaintenanceTask({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.estimatedTime,
    required this.status,
  });
}
