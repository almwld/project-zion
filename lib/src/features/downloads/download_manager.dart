import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class DownloadManager extends StatefulWidget {
  const DownloadManager({super.key});

  @override
  State<DownloadManager> createState() => _DownloadManagerState();
}

class _DownloadManagerState extends State<DownloadManager> {
  final List<DownloadItem> _downloads = [];
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  String _selectedCategory = 'All';
  bool _isPaused = false;

  final List<String> _categories = ['All', 'Active', 'Completed', 'Paused', 'Failed'];

  @override
  void initState() {
    super.initState();
    _loadSampleDownloads();
  }

  void _loadSampleDownloads() {
    _downloads.addAll([
      DownloadItem(
        id: '1',
        fileName: 'Zion_OS_v3.3.apk',
        url: 'https://github.com/almwld/project-zion/releases/download/v3.3/zion-os.apk',
        fileSize: 55 * 1024 * 1024,
        downloadedSize: 25 * 1024 * 1024,
        status: 'Downloading',
        progress: 0.45,
        speed: 2.5,
        timeRemaining: 12,
        category: 'Active',
      ),
      DownloadItem(
        id: '2',
        fileName: 'network_tools.zip',
        url: 'https://example.com/network_tools.zip',
        fileSize: 120 * 1024 * 1024,
        downloadedSize: 120 * 1024 * 1024,
        status: 'Completed',
        progress: 1.0,
        speed: 0,
        timeRemaining: 0,
        category: 'Completed',
      ),
      DownloadItem(
        id: '3',
        fileName: 'security_scan_results.pdf',
        url: 'https://example.com/report.pdf',
        fileSize: 5 * 1024 * 1024,
        downloadedSize: 2 * 1024 * 1024,
        status: 'Paused',
        progress: 0.4,
        speed: 0,
        timeRemaining: 0,
        category: 'Paused',
      ),
    ]);
  }

  Future<void> _addDownload() async {
    if (_urlController.text.isEmpty) return;

    final newDownload = DownloadItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: _fileNameController.text.isEmpty ? _extractFileName(_urlController.text) : _fileNameController.text,
      url: _urlController.text,
      fileSize: 0,
      downloadedSize: 0,
      status: 'Queued',
      progress: 0,
      speed: 0,
      timeRemaining: 0,
      category: 'Active',
    );

    setState(() {
      _downloads.insert(0, newDownload);
    });

    _urlController.clear();
    _fileNameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download added to queue')),
    );

    _startDownload(newDownload);
  }

  Future<void> _startDownload(DownloadItem download) async {
    try {
      final client = http.Client();
      final request = await client.send(http.Request('GET', Uri.parse(download.url)));
      final totalSize = request.contentLength ?? 0;
      
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${download.fileName}');
      
      var received = 0;
      final stream = request.stream.listen((chunk) {
        received += chunk.length;
        final progress = received / totalSize;
        final speed = received / (DateTime.now().millisecondsSinceEpoch / 1000);
        final remaining = (totalSize - received) / speed;
        
        setState(() {
          download.fileSize = totalSize;
          download.downloadedSize = received;
          download.progress = progress;
          download.speed = speed / (1024 * 1024);
          download.timeRemaining = remaining.toInt();
          download.status = 'Downloading';
          download.category = 'Active';
        });
        
        file.writeAsBytesSync(chunk, mode: FileMode.append);
      });
      
      await stream.asFuture();
      
      setState(() {
        download.status = 'Completed';
        download.progress = 1.0;
        download.category = 'Completed';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download completed: ${download.fileName}')),
      );
    } catch (e) {
      setState(() {
        download.status = 'Failed';
        download.category = 'Failed';
      });
    }
  }

  void _pauseDownload(String id) {
    setState(() {
      final index = _downloads.indexWhere((d) => d.id == id);
      if (index != -1 && _downloads[index].status == 'Downloading') {
        _downloads[index].status = 'Paused';
        _downloads[index].category = 'Paused';
      }
    });
  }

  void _resumeDownload(String id) {
    setState(() {
      final index = _downloads.indexWhere((d) => d.id == id);
      if (index != -1 && _downloads[index].status == 'Paused') {
        _downloads[index].status = 'Queued';
        _downloads[index].category = 'Active';
        _startDownload(_downloads[index]);
      }
    });
  }

  void _cancelDownload(String id) {
    setState(() {
      _downloads.removeWhere((d) => d.id == id);
    });
  }

  void _retryDownload(String id) {
    final index = _downloads.indexWhere((d) => d.id == id);
    if (index != -1) {
      final download = _downloads[index];
      download.status = 'Queued';
      download.progress = 0;
      download.downloadedSize = 0;
      download.category = 'Active';
      _startDownload(download);
    }
  }

  String _extractFileName(String url) {
    final parts = url.split('/');
    return parts.last.isNotEmpty ? parts.last : 'download_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatSpeed(double speedMBps) {
    return '${speedMBps.toStringAsFixed(1)} MB/s';
  }

  List<DownloadItem> get _filteredDownloads {
    if (_selectedCategory == 'All') return _downloads;
    return _downloads.where((d) => d.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Download Manager'),
        backgroundColor: Colors.orange.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAddDownloadCard()),
          SliverToBoxAdapter(child: _buildFilterChips()),
          SliverToBoxAdapter(child: _buildStatsCard()),
          SliverToBoxAdapter(child: _buildDownloadsList()),
        ],
      ),
    );
  }

  Widget _buildAddDownloadCard() {
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
          const Text('Add Download', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _urlController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'URL',
              labelStyle: TextStyle(color: Colors.orange),
              border: OutlineInputBorder(),
              hintText: 'https://...',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fileNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'File Name (optional)',
              labelStyle: TextStyle(color: Colors.orange),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _addDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('ADD TO QUEUE'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (ctx, i) {
          final category = _categories[i];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: Colors.grey.shade800,
              selectedColor: Colors.orange,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    final activeCount = _downloads.where((d) => d.category == 'Active').length;
    final completedCount = _downloads.where((d) => d.category == 'Completed').length;
    final totalSize = _downloads.fold<int>(0, (sum, d) => sum + d.fileSize);
    
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
          _buildStatItem('Active', '$activeCount', Colors.blue),
          _buildStatItem('Completed', '$completedCount', Colors.green),
          _buildStatItem('Total Size', _formatSize(totalSize), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildDownloadsList() {
    if (_filteredDownloads.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No downloads found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredDownloads.length,
      itemBuilder: (ctx, i) {
        final download = _filteredDownloads[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
            border: download.status == 'Downloading'
                ? Border.all(color: Colors.blue, width: 1)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getStatusIcon(download.status), color: _getStatusColor(download.status)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      download.fileName,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (download.status == 'Downloading')
                    IconButton(
                      icon: const Icon(Icons.pause, color: Colors.orange),
                      onPressed: () => _pauseDownload(download.id),
                    ),
                  if (download.status == 'Paused')
                    IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.green),
                      onPressed: () => _resumeDownload(download.id),
                    ),
                  if (download.status == 'Completed')
                    IconButton(
                      icon: const Icon(Icons.folder_open, color: Colors.blue),
                      onPressed: () {},
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _cancelDownload(download.id),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: download.progress,
                backgroundColor: Colors.grey.shade800,
                color: _getStatusColor(download.status),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formatSize(download.downloadedSize)} / ${_formatSize(download.fileSize)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  if (download.status == 'Downloading')
                    Text(
                      '${_formatSpeed(download.speed)} • ${download.timeRemaining}s remaining',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  if (download.status == 'Failed')
                    TextButton(
                      onPressed: () => _retryDownload(download.id),
                      child: const Text('Retry', style: TextStyle(color: Colors.blue)),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Downloading': return Icons.downloading;
      case 'Completed': return Icons.check_circle;
      case 'Paused': return Icons.pause_circle;
      case 'Failed': return Icons.error;
      default: return Icons.pending;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Downloading': return Colors.blue;
      case 'Completed': return Colors.green;
      case 'Paused': return Colors.orange;
      case 'Failed': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class DownloadItem {
  final String id;
  final String fileName;
  final String url;
  int fileSize;
  int downloadedSize;
  String status;
  double progress;
  double speed;
  int timeRemaining;
  String category;

  DownloadItem({
    required this.id,
    required this.fileName,
    required this.url,
    required this.fileSize,
    required this.downloadedSize,
    required this.status,
    required this.progress,
    required this.speed,
    required this.timeRemaining,
    required this.category,
  });
}
