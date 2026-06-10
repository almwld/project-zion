import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class SystemCleaner extends StatefulWidget {
  const SystemCleaner({super.key});

  @override
  State<SystemCleaner> createState() => _SystemCleanerState();
}

class _SystemCleanerState extends State<SystemCleaner> {
  bool _isScanning = false;
  bool _isCleaning = false;
  int _totalCacheSize = 0;
  int _totalTempSize = 0;
  int _totalLogSize = 0;
  int _totalUnusedSize = 0;
  List<CleanupItem> _scanResults = [];

  @override
  void initState() {
    super.initState();
    _loadCacheSizes();
  }

  Future<void> _loadCacheSizes() async {
    // محاكاة أحجام الملفات
    setState(() {
      _totalCacheSize = 245; // MB
      _totalTempSize = 128; // MB
      _totalLogSize = 67; // MB
      _totalUnusedSize = 89; // MB
      
      _scanResults = [
        CleanupItem(name: 'App Cache', size: _totalCacheSize, icon: Icons.cached, color: Colors.orange),
        CleanupItem(name: 'Temporary Files', size: _totalTempSize, icon: Icons.delete_sweep, color: Colors.blue),
        CleanupItem(name: 'Log Files', size: _totalLogSize, icon: Icons.description, color: Colors.green),
        CleanupItem(name: 'Unused APKs', size: _totalUnusedSize, icon: Icons.android, color: Colors.red),
      ];
    });
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResults = [];
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isScanning = false;
      _loadCacheSizes();
    });
  }

  Future<void> _startClean() async {
    setState(() => _isCleaning = true);
    
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _totalCacheSize = 0;
      _totalTempSize = 0;
      _totalLogSize = 0;
      _totalUnusedSize = 0;
      _scanResults = [];
      _isCleaning = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System cleaned successfully!')),
    );
  }

  int get _totalSize => _totalCacheSize + _totalTempSize + _totalLogSize + _totalUnusedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('System Cleaner'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildStorageCard()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildScanResults()),
        ],
      ),
    );
  }

  Widget _buildStorageCard() {
    final usedPercent = _totalSize / 1024; // 1GB تقريبي
    final used = usedPercent.clamp(0.0, 1.0);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.storage, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text('Storage Analysis', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStorageStat('Total', '64 GB', Colors.grey),
              _buildStorageStat('Used', '${(_totalSize / 1024).toStringAsFixed(1)} GB', Colors.blue),
              _buildStorageStat('Free', '${(64 - _totalSize / 1024).toStringAsFixed(1)} GB', Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: used,
            backgroundColor: Colors.grey.shade800,
            color: Colors.blue,
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
              onPressed: _isScanning ? null : _startScan,
              icon: const Icon(Icons.search),
              label: const Text('SCAN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: (_isScanning || _totalSize == 0 || _isCleaning) ? null : _startClean,
              icon: const Icon(Icons.cleaning_services),
              label: Text(_isCleaning ? 'CLEANING...' : 'CLEAN ALL'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanResults() {
    if (_isScanning) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Scanning system...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    if (_scanResults.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text('System is clean!', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

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
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Junk Files Found', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ..._scanResults.map((item) => ListTile(
            leading: Icon(item.icon, color: item.color),
            title: Text(item.name, style: const TextStyle(color: Colors.white)),
            trailing: Text(_formatSize(item.size), style: TextStyle(color: item.color, fontWeight: FontWeight.bold)),
          )),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.total, color: Colors.white),
            title: const Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: Text(_formatSize(_totalSize), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatSize(int sizeMB) {
    if (sizeMB < 1024) return '$sizeMB MB';
    return '${(sizeMB / 1024).toStringAsFixed(1)} GB';
  }
}

class CleanupItem {
  final String name;
  final int size;
  final IconData icon;
  final Color color;

  CleanupItem({
    required this.name,
    required this.size,
    required this.icon,
    required this.color,
  });
}
