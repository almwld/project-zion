import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class CloudCenter extends StatefulWidget {
  const CloudCenter({super.key});

  @override
  State<CloudCenter> createState() => _CloudCenterState();
}

class _CloudCenterState extends State<CloudCenter> {
  int _selectedTab = 0;
  
  // Cloud Services
  List<CloudService> _services = [];
  double _totalCloudStorage = 0;
  double _usedCloudStorage = 0;
  
  // Remote Backups
  List<RemoteBackup> _backups = [];
  bool _isBackingUp = false;
  double _backupProgress = 0;
  
  // File Sync
  List<SyncFile> _syncFiles = [];
  bool _isSyncing = false;
  int _syncProgress = 0;
  
  // Storage Analytics
  List<StorageMetric> _metrics = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadCloudServices();
    _loadBackups();
    _loadSyncFiles();
    _loadMetrics();
    _calculateStorage();
  }

  void _loadCloudServices() {
    _services = [
      CloudService('Google Drive', '15 GB', 8.5, 'Connected', Icons.cloud, Colors.blue, 0.57),
      CloudService('Dropbox', '5 GB', 3.2, 'Connected', Icons.cloud_queue, Colors.indigo, 0.64),
      CloudService('OneDrive', '10 GB', 4.5, 'Connected', Icons.cloud_upload, Colors.cyan, 0.45),
      CloudService('iCloud', '5 GB', 2.8, 'Disconnected', Icons.apple, Colors.grey, 0),
      CloudService('Mega', '20 GB', 6.5, 'Connected', Icons.cloud_done, Colors.red, 0.33),
    ];
    _calculateTotalStorage();
  }

  void _calculateTotalStorage() {
    double total = 0;
    double used = 0;
    for (var service in _services) {
      final size = double.parse(service.totalSize.split(' ')[0]);
      total += size;
      used += size * service.usedPercentage;
    }
    _totalCloudStorage = total;
    _usedCloudStorage = used;
  }

  void _loadBackups() {
    _backups = [
      RemoteBackup('System Backup', DateTime.now().subtract(const Duration(hours: 2)), 256, 'Completed', 'Google Drive'),
      RemoteBackup('User Data', DateTime.now().subtract(const Duration(days: 1)), 512, 'Completed', 'Dropbox'),
      RemoteBackup('Config Files', DateTime.now().subtract(const Duration(days: 3)), 128, 'Completed', 'OneDrive'),
      RemoteBackup('Logs Archive', DateTime.now().subtract(const Duration(days: 7)), 64, 'Failed', 'Google Drive'),
    ];
  }

  void _loadSyncFiles() {
    _syncFiles = [
      SyncFile('document.pdf', 'Documents', 2.5, 'Synced', DateTime.now().subtract(const Duration(minutes: 30))),
      SyncFile('image.png', 'Pictures', 5.2, 'Syncing', DateTime.now().subtract(const Duration(minutes: 5))),
      SyncFile('video.mp4', 'Videos', 125, 'Pending', DateTime.now().subtract(const Duration(hours: 1))),
      SyncFile('backup.zip', 'Backups', 45, 'Synced', DateTime.now().subtract(const Duration(days: 1))),
      SyncFile('report.pdf', 'Documents', 1.8, 'Failed', DateTime.now().subtract(const Duration(hours: 3))),
    ];
  }

  void _loadMetrics() {
    _metrics = [
      StorageMetric('Google Drive', 8.5, 15, 2500),
      StorageMetric('Dropbox', 3.2, 5, 1200),
      StorageMetric('OneDrive', 4.5, 10, 800),
      StorageMetric('Mega', 6.5, 20, 3100),
    ];
  }

  void _calculateStorage() {
    setState(() {
      _calculateTotalStorage();
    });
  }

  void _startBackup() {
    setState(() {
      _isBackingUp = true;
      _backupProgress = 0;
    });
    
    final timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _backupProgress += 0.01;
        if (_backupProgress >= 1.0) {
          timer.cancel();
          _isBackingUp = false;
          _backups.insert(0, RemoteBackup('Manual Backup', DateTime.now(), 512, 'Completed', 'Google Drive'));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup completed successfully!')),
          );
        }
      });
    });
  }

  void _startSync() {
    setState(() {
      _isSyncing = true;
      _syncProgress = 0;
    });
    
    final timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _syncProgress += 0.01;
        if (_syncProgress >= 1.0) {
          timer.cancel();
          _isSyncing = false;
          for (var file in _syncFiles) {
            if (file.status == 'Syncing') {
              file.status = 'Synced';
              file.lastSync = DateTime.now();
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sync completed!')),
          );
        }
      });
    });
  }

  void _retrySync(SyncFile file) {
    setState(() {
      file.status = 'Syncing';
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        file.status = 'Synced';
        file.lastSync = DateTime.now();
      });
    });
  }

  void _connectService(CloudService service) {
    setState(() {
      service.status = 'Connected';
    });
    _calculateStorage();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${service.name} connected!')),
    );
  }

  void _disconnectService(CloudService service) {
    setState(() {
      service.status = 'Disconnected';
      service.usedPercentage = 0;
    });
    _calculateStorage();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${service.name} disconnected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cloud Center'),
        backgroundColor: Colors.lightBlue.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.cloud), text: 'Services'),
            Tab(icon: Icon(Icons.backup), text: 'Backups'),
            Tab(icon: Icon(Icons.sync), text: 'Sync'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildServicesTab(),
          _buildBackupsTab(),
          _buildSyncTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
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
                colors: [Colors.lightBlue.shade900, Colors.cyan.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Total Cloud Storage', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: _usedCloudStorage / _totalCloudStorage,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.cyan,
                      ),
                    ),
                    Column(
                      children: [
                        Text('${(_usedCloudStorage / _totalCloudStorage * 100).toStringAsFixed(1)}%', 
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text('Used', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${_usedCloudStorage.toStringAsFixed(1)} GB / ${_totalCloudStorage.toStringAsFixed(1)} GB',
                  style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._services.map((service) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: service.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(service.icon, color: service.color, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('${service.used} GB / ${service.totalSize}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: service.status == 'Connected' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(service.status, style: TextStyle(color: service.status == 'Connected' ? Colors.green : Colors.red)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: service.usedPercentage,
                  backgroundColor: Colors.grey.shade800,
                  color: service.color,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (service.status != 'Connected')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _connectService(service),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('CONNECT'),
                        ),
                      ),
                    if (service.status == 'Connected')
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _disconnectService(service),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('DISCONNECT'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBackupsTab() {
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
            children: [
              const Text('Create New Backup', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              if (_isBackingUp) ...[
                LinearProgressIndicator(value: _backupProgress),
                const SizedBox(height: 8),
                Text('${(_backupProgress * 100).toInt()}%', style: const TextStyle(color: Colors.white70)),
              ] else
                ElevatedButton(
                  onPressed: _startBackup,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('START BACKUP'),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _backups.length,
            itemBuilder: (ctx, i) {
              final backup = _backups[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      backup.status == 'Completed' ? Icons.check_circle : Icons.error,
                      color: backup.status == 'Completed' ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(backup.name, style: const TextStyle(color: Colors.white)),
                          Text('${backup.size} MB • ${backup.location} • ${_formatDate(backup.date)}',
                            style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(backup.status, style: TextStyle(color: backup.status == 'Completed' ? Colors.green : Colors.red)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSyncTab() {
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
            children: [
              const Text('File Synchronization', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              if (_isSyncing) ...[
                LinearProgressIndicator(value: _syncProgress / 100),
                const SizedBox(height: 8),
                Text('${_syncProgress}%', style: const TextStyle(color: Colors.white70)),
              ] else
                ElevatedButton(
                  onPressed: _startSync,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('SYNC NOW'),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _syncFiles.length,
            itemBuilder: (ctx, i) {
              final file = _syncFiles[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      file.status == 'Synced' ? Icons.cloud_done :
                      file.status == 'Syncing' ? Icons.cloud_sync :
                      file.status == 'Pending' ? Icons.cloud_queue : Icons.cloud_off,
                      color: file.status == 'Synced' ? Colors.green :
                             file.status == 'Syncing' ? Colors.orange : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(file.name, style: const TextStyle(color: Colors.white)),
                          Text('${file.size} MB • ${file.folder} • ${_formatDateTime(file.lastSync)}',
                            style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    if (file.status == 'Failed')
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.blue),
                        onPressed: () => _retrySync(file),
                      ),
                    Text(file.status, style: TextStyle(color: file.status == 'Synced' ? Colors.green : Colors.orange)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollUp(

      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Storage Distribution', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._metrics.map((metric) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.cloud, color: Colors.blue),
                  ),
                  title: Text(metric.service, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${metric.files} files', style: const TextStyle(color: Colors.grey)),
                  trailing: Text('${metric.used}/${metric.total} GB', style: const TextStyle(color: Colors.white70)),
                )),
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
                const Text('Storage Trends', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 30,
                    itemBuilder: (ctx, i) {
                      final random = Random();
                      final height = 30 + random.nextInt(150);
                      return Container(
                        width: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: height.toDouble(),
                        color: Colors.blue.withOpacity(0.5 + i * 0.01),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  String _formatDateTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

class CloudService {
  final String name;
  final String totalSize;
  final double used;
  String status;
  final IconData icon;
  final Color color;
  double usedPercentage;

  CloudService(this.name, this.totalSize, this.used, this.status, this.icon, this.color, this.usedPercentage);
}

class RemoteBackup {
  final String name;
  final DateTime date;
  final int size;
  final String status;
  final String location;

  RemoteBackup(this.name, this.date, this.size, this.status, this.location);
}

class SyncFile {
  final String name;
  final String folder;
  final double size;
  String status;
  DateTime lastSync;

  SyncFile(this.name, this.folder, this.size, this.status, this.lastSync);
}

class StorageMetric {
  final String service;
  final double used;
  final double total;
  final int files;

  StorageMetric(this.service, this.used, this.total, this.files);
}
