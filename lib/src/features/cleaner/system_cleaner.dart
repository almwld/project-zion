import 'package:flutter/material.dart';
import 'dart:async';

class SystemCleaner extends StatefulWidget {
  const SystemCleaner({super.key});

  @override
  State<SystemCleaner> createState() => _SystemCleanerState();
}

class _SystemCleanerState extends State<SystemCleaner> {
  bool _isScanning = false;
  bool _isCleaning = false;
  int _cacheSize = 245;
  int _tempSize = 128;

  Future<void> _startClean() async {
    setState(() {
      _isCleaning = true;
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _cacheSize = 0;
      _tempSize = 0;
      _isCleaning = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System cleaned successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSize = _cacheSize + _tempSize;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('System Cleaner'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Storage Card
            Container(
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
                      _buildStat('Cache', '$_cacheSize MB', Colors.orange),
                      _buildStat('Temp', '$_tempSize MB', Colors.blue),
                      _buildStat('Total', '$totalSize MB', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Clean Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_isScanning || totalSize == 0 || _isCleaning) ? null : _startClean,
                icon: const Icon(Icons.cleaning_services),
                label: Text(_isCleaning ? 'CLEANING...' : 'CLEAN ALL'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
