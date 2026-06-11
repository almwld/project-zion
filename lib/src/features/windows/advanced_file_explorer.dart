import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AdvancedFileExplorer extends StatefulWidget {
  const AdvancedFileExplorer({super.key});

  @override
  State<AdvancedFileExplorer> createState() => _AdvancedFileExplorerState();
}

class _AdvancedFileExplorerState extends State<AdvancedFileExplorer> {
  Directory _currentDirectory = Directory('/storage/emulated/0');
  List<FileSystemEntity> _items = [];
  String _currentPath = '';
  String _searchQuery = '';
  bool _showHidden = false;
  bool _isLoading = true;
  String _viewMode = 'grid'; // grid, list, details

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadDirectory();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<void> _loadDirectory() async {
    setState(() => _isLoading = true);
    try {
      final items = await _currentDirectory.list().toList();
      items.sort((a, b) {
        if (a is Directory && b is File) return -1;
        if (a is File && b is Directory) return 1;
        return a.path.compareTo(b.path);
      });
      setState(() {
        _items = items;
        _currentPath = _currentDirectory.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _navigateTo(Directory dir) {
    setState(() {
      _currentDirectory = dir;
      _loadDirectory();
    });
  }

  void _navigateUp() {
    if (_currentDirectory.path != '/') {
      setState(() {
        _currentDirectory = Directory(_currentDirectory.path).parent;
        _loadDirectory();
      });
    }
  }

  Future<void> _createFolder() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Folder'),
        backgroundColor: Colors.grey.shade900,
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Folder name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final newFolder = Directory('${_currentDirectory.path}/${controller.text}');
              await newFolder.create();
              Navigator.pop(ctx);
              _loadDirectory();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(FileSystemEntity item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Delete ${item.path.split('/').last}?'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        if (item is File) await item.delete();
        else if (item is Directory) await item.delete(recursive: true);
        _loadDirectory();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _shareFile(File file) async {
    await Share.shareXFiles([XFile(file.path)]);
  }

  Future<void> _renameItem(FileSystemEntity item) async {
    final controller = TextEditingController(text: item.path.split('/').last);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename'),
        backgroundColor: Colors.grey.shade900,
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'New name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final newPath = '${_currentDirectory.path}/${controller.text}';
              await item.rename(newPath);
              Navigator.pop(ctx);
              _loadDirectory();
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyItem(FileSystemEntity item) async {
    // محاكاة النسخ
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copy feature coming soon')),
    );
  }

  Future<void> _moveItem(FileSystemEntity item) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Move feature coming soon')),
    );
  }

  List<FileSystemEntity> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((item) =>
      item.path.split('/').last.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_currentPath, style: const TextStyle(fontSize: 12)),
        backgroundColor: Colors.orange.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateUp,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: Icon(_viewMode == 'grid' ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _viewMode = _viewMode == 'grid' ? 'list' : 'grid'),
          ),
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: _createFolder,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDirectory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredItems.isEmpty
              ? const Center(child: Text('No files found', style: TextStyle(color: Colors.grey)))
              : _viewMode == 'grid'
                  ? _buildGridView()
                  : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (ctx, i) {
        final item = _filteredItems[i];
        final isDirectory = item is Directory;
        final name = item.path.split('/').last;
        final icon = isDirectory ? Icons.folder : _getFileIcon(name);
        final color = isDirectory ? Colors.orange : Colors.blue;
        
        return GestureDetector(
          onTap: () {
            if (isDirectory) _navigateTo(item as Directory);
          },
          onLongPress: () => _showItemMenu(item),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 48),
                const SizedBox(height: 8),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (ctx, i) {
        final item = _filteredItems[i];
        final isDirectory = item is Directory;
        final name = item.path.split('/').last;
        final icon = isDirectory ? Icons.folder : _getFileIcon(name);
        final color = isDirectory ? Colors.orange : Colors.blue;
        
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(name, style: const TextStyle(color: Colors.white)),
            subtitle: isDirectory ? null : Text(_formatSize(item.statSync().size), style: const TextStyle(color: Colors.grey)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blue),
                  onPressed: () => _copyItem(item),
                ),
                IconButton(
                  icon: const Icon(Icons.drive_file_rename_outline, color: Colors.orange),
                  onPressed: () => _renameItem(item),
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.green),
                  onPressed: () => isDirectory ? null : _shareFile(item as File),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteItem(item),
                ),
              ],
            ),
            onTap: () {
              if (isDirectory) _navigateTo(item as Directory);
            },
            onLongPress: () => _showItemMenu(item),
          ),
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search'),
        backgroundColor: Colors.grey.shade900,
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search files...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        actions: [
          TextButton(onPressed: () {
            setState(() => _searchQuery = '');
            Navigator.pop(ctx);
          }, child: const Text('Clear')),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showItemMenu(FileSystemEntity item) {
    final isDirectory = item is Directory;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline, color: Colors.orange),
              title: const Text('Rename', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _renameItem(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.blue),
              title: const Text('Copy', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _copyItem(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move, color: Colors.purple),
              title: const Text('Move', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _moveItem(item);
              },
            ),
            if (!isDirectory)
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _shareFile(item as File);
                },
              ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.cyan),
              title: const Text('Properties', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _showProperties(item);
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _deleteItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProperties(FileSystemEntity item) {
    final isDirectory = item is Directory;
    final stat = item.statSync();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.path.split('/').last),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${isDirectory ? "Folder" : "File"}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Size: ${isDirectory ? "—" : _formatSize(stat.size)}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Path: ${item.path}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 8),
            Text('Modified: ${stat.modified}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  IconData _getFileIcon(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg': case 'jpeg': case 'png': case 'gif': return Icons.image;
      case 'mp3': case 'wav': case 'flac': return Icons.audiotrack;
      case 'mp4': case 'avi': case 'mkv': return Icons.video_library;
      case 'pdf': return Icons.picture_as_pdf;
      case 'doc': case 'docx': return Icons.description;
      case 'xls': case 'xlsx': return Icons.table_chart;
      case 'ppt': case 'pptx': return Icons.slideshow;
      case 'zip': case 'rar': case '7z': return Icons.archive;
      case 'apk': return Icons.android;
      case 'dart': case 'txt': return Icons.code;
      default: return Icons.insert_drive_file;
    }
  }
}
