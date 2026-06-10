import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class BackupRestoreCenter extends StatefulWidget {
  const BackupRestoreCenter({super.key});

  @override
  State<BackupRestoreCenter> createState() => _BackupRestoreCenterState();
}

class _BackupRestoreCenterState extends State<BackupRestoreCenter> {
  List<BackupItem> _backups = [];
  bool _isBackingUp = false;
  bool _isRestoring = false;
  double _backupProgress = 0.0;
  String _selectedBackupLocation = 'Internal Storage';
  int _totalBackupSize = 0;
  int _lastBackupDate = 0;

  final List<String> _backupLocations = ['Internal Storage', 'SD Card', 'Cloud', 'External USB'];

  @override
  void initState() {
    super.initState();
    _loadBackups();
    _calculateStats();
  }

  void _loadBackups() {
    _backups = [
      BackupItem(
        id: '1',
        name: 'Full System Backup',
        date: DateTime.now().subtract(const Duration(days: 1)),
        size: 2450,
        type: 'Full',
        location: 'Internal Storage',
        status: 'Completed',
      ),
      BackupItem(
        id: '2',
        name: 'App Data Backup',
        date: DateTime.now().subtract(const Duration(days: 3)),
        size: 890,
        type: 'App Data',
        location: 'Internal Storage',
        status: 'Completed',
      ),
      BackupItem(
        id: '3',
        name: 'Configuration Backup',
        date: DateTime.now().subtract(const Duration(days: 7)),
        size: 125,
        type: 'Config',
        location: 'Cloud',
        status: 'Completed',
      ),
    ];
  }

  void _calculateStats() {
    _totalBackupSize = _backups.fold<int>(0, (sum, b) => sum + b.size);
    if (_backups.isNotEmpty) {
      _lastBackupDate = DateTime.now().difference(_backups.first.date).inDays;
    }
  }

  Future<void> _createBackup() async {
    setState(() {
      _isBackingUp = true;
      _backupProgress = 0.0;
    });

    for (var i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _backupProgress = i / 100);
    }

    final newBackup = BackupItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Backup ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      date: DateTime.now(),
      size: 1250 + (DateTime.now().millisecondsSinceEpoch % 1000).toInt(),
      type: 'Full',
      location: _selectedBackupLocation,
      status: 'Completed',
    );

    setState(() {
      _backups.insert(0, newBackup);
      _isBackingUp = false;
      _totalBackupSize += newBackup.size;
      _lastBackupDate = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup created successfully!')),
    );
  }

  Future<void> _restoreBackup(BackupItem backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup'),
        content: Text('Are you sure you want to restore "${backup.name}"? Current data will be overwritten.'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Restore', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isRestoring = true);

      await Future.delayed(const Duration(seconds: 3));

      setState(() => _isRestoring = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restored from backup: ${backup.name}')),
      );
    }
  }

  void _deleteBackup(String id) {
    setState(() {
      final removed = _backups.firstWhere((b) => b.id == id);
      _backups.removeWhere((b) => b.id == id);
      _totalBackupSize -= removed.size;
    });
  }

  void _scheduleBackup() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Schedule Backup'),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.daily, color: Colors.blue),
              title: Text('Daily', style: TextStyle(color: Colors.white)),
            ),
            const ListTile(
              leading: Icon(Icons.weekly, color: Colors.green),
              title: Text('Weekly', style: TextStyle(color: Colors.white)),
            ),
            const ListTile(
              leading: Icon(Icons.monthly, color: Colors.orange),
              title: Text('Monthly', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  String _formatSize(int mb) {
    if (mb < 1024) return '$mb MB';
    return '${(mb / 1024).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildBackupCard()),
          SliverToBoxAdapter(child: _buildStatsCard()),
          SliverToBoxAdapter(child: _buildBackupList()),
        ],
      ),
    );
  }

  Widget _buildBackupCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.backup, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text('Create Backup', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedBackupLocation,
            items: _backupLocations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
            onChanged: (v) => setState(() => _selectedBackupLocation = v!),
            decoration: const InputDecoration(
              labelText: 'Backup Location',
              labelStyle: TextStyle(color: Colors.indigo),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (_isBackingUp)
            Column(
              children: [
                LinearProgressIndicator(value: _backupProgress, color: Colors.indigo),
                const SizedBox(height: 8),
                Text('${(_backupProgress * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white)),
              ],
            )
          else
            ElevatedButton(
              onPressed: _createBackup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('CREATE BACKUP'),
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
          _buildStatItem('Backups', '${_backups.length}', Icons.archive, Colors.blue),
          _buildStatItem('Total Size', _formatSize(_totalBackupSize), Icons.storage, Colors.green),
          _buildStatItem('Last Backup', '$_lastBackupDate days ago', Icons.history, Colors.orange),
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

  Widget _buildBackupList() {
    if (_backups.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No backups found', style: TextStyle(color: Colors.grey)),
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
              Icon(Icons.history, color: Colors.indigo),
              SizedBox(width: 8),
              Text('Backup History', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ..._backups.map((backup) => ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo.withOpacity(0.2),
              child: Icon(Icons.backup, color: Colors.indigo),
            ),
            title: Text(backup.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '${_formatDate(backup.date)} • ${_formatSize(backup.size)} • ${backup.type} • ${backup.location}',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.restore, color: Colors.green),
                  onPressed: () => _restoreBackup(backup),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteBackup(backup.id),
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _scheduleBackup,
            icon: const Icon(Icons.schedule),
            label: const Text('SCHEDULE AUTOMATIC BACKUP'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }
}

class BackupItem {
  final String id;
  final String name;
  final DateTime date;
  final int size;
  final String type;
  final String location;
  final String status;

  BackupItem({
    required this.id,
    required this.name,
    required this.date,
    required this.size,
    required this.type,
    required this.location,
    required this.status,
  });
}
