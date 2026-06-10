import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ContainerManager extends StatefulWidget {
  const ContainerManager({super.key});

  @override
  State<ContainerManager> createState() => _ContainerManagerState();
}

class _ContainerManagerState extends State<ContainerManager> {
  int _selectedTab = 0;
  
  // Containers
  List<Container> _containers = [];
  List<Container> _activeContainers = [];
  List<Container> _stoppedContainers = [];
  
  // Images
  List<Image> _images = [];
  double _totalImageSize = 0;
  
  // Applications
  List<App> _installedApps = [];
  List<App> _runningApps = [];
  
  // Resources
  Map<String, double> _containerResources = {};
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadContainers();
    _loadImages();
    _loadApps();
    _startRefresh();
  }

  void _loadContainers() {
    _containers = [
      Container('zion-core', 'Running', 'ubuntu:22.04', '2.5 GB', '10 min', Icons.docker, Colors.blue, 45, 256),
      Container('zion-db', 'Running', 'postgres:15', '1.8 GB', '2 hours', Icons.storage, Colors.green, 32, 512),
      Container('zion-cache', 'Stopped', 'redis:7', '500 MB', '1 day', Icons.speed, Colors.orange, 0, 128),
      Container('zion-web', 'Running', 'nginx:alpine', '400 MB', '30 min', Icons.public, Colors.cyan, 12, 64),
      Container('zion-ai', 'Stopped', 'tensorflow:latest', '3.2 GB', '3 days', Icons.psychology, Colors.purple, 0, 1024),
    ];
    
    _activeContainers = _containers.where((c) => c.status == 'Running').toList();
    _stoppedContainers = _containers.where((c) => c.status == 'Stopped').toList();
    
    _containerResources = {
      'zion-core': 45,
      'zion-db': 32,
      'zion-web': 12,
    };
  }

  void _loadImages() {
    _images = [
      Image('ubuntu:22.04', '1.2 GB', '2 months ago', Icons.ubuntu, Colors.orange),
      Image('postgres:15', '800 MB', '1 month ago', Icons.storage, Colors.blue),
      Image('nginx:alpine', '150 MB', '3 weeks ago', Icons.public, Colors.green),
      Image('redis:7', '250 MB', '2 weeks ago', Icons.speed, Colors.red),
      Image('tensorflow:latest', '2.5 GB', '1 week ago', Icons.psychology, Colors.purple),
    ];
    
    _totalImageSize = _images.map((i) => double.parse(i.size.split(' ')[0])).reduce((a, b) => a + b);
  }

  void _loadApps() {
    _installedApps = [
      App('Zion OS Core', '1.0.0', 'Running', Icons.android, Colors.green, 128),
      App('SI Agent', '2.1.0', 'Running', Icons.psychology, Colors.purple, 256),
      App('Network Scanner', '3.0.0', 'Stopped', Icons.network_check, Colors.cyan, 64),
      App('Security Suite', '1.5.0', 'Running', Icons.security, Colors.red, 96),
    ];
    
    _runningApps = _installedApps.where((a) => a.status == 'Running').toList();
  }

  void _startRefresh() {
    final random = Random();
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        for (var container in _activeContainers) {
          container.cpuUsage = (container.cpuUsage + (random.nextDouble() - 0.5) * 10).clamp(0.0, 100.0);
          container.memoryUsage = (container.memoryUsage + (random.nextInt(20) - 10)).clamp(0, 1024);
        }
        
        for (var key in _containerResources.keys) {
          _containerResources[key] = (_containerResources[key]! + (random.nextDouble() - 0.5) * 5).clamp(0.0, 100.0);
        }
      });
    });
  }

  void _startContainer(Container container) {
    setState(() {
      container.status = 'Running';
      _activeContainers.add(container);
      _stoppedContainers.remove(container);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${container.name} started')),
    );
  }

  void _stopContainer(Container container) {
    setState(() {
      container.status = 'Stopped';
      _stoppedContainers.add(container);
      _activeContainers.remove(container);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${container.name} stopped')),
    );
  }

  void _restartContainer(Container container) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Restarting ${container.name}...')),
    );
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${container.name} restarted')),
      );
    });
  }

  void _removeImage(Image image) {
    setState(() {
      _images.remove(image);
      _totalImageSize -= double.parse(image.size.split(' ')[0]);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${image.name} removed')),
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
        title: const Text('Container Manager'),
        backgroundColor: Colors.indigo.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Containers'),
            Tab(icon: Icon(Icons.image), text: 'Images'),
            Tab(icon: Icon(Icons.apps), text: 'Applications'),
            Tab(icon: Icon(Icons.analytics), text: 'Resources'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildContainersTab(),
          _buildImagesTab(),
          _buildAppsTab(),
          _buildResourcesTab(),
        ],
      ),
    );
  }

  Widget _buildContainersTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade900,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.play_circle), text: 'Running'),
                Tab(icon: Icon(Icons.stop_circle), text: 'Stopped'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: _activeContainers.length,
                  itemBuilder: (ctx, i) => _buildContainerCard(_activeContainers[i]),
                ),
                ListView.builder(
                  itemCount: _stoppedContainers.length,
                  itemBuilder: (ctx, i) => _buildContainerCard(_stoppedContainers[i]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainerCard(Container container) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: container.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(container.icon, color: container.color),
        ),
        title: Text(container.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('${container.image} • ${container.size}', style: const TextStyle(color: Colors.grey)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (container.status == 'Running')
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.red),
                onPressed: () => _stopContainer(container),
              ),
            if (container.status == 'Stopped')
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                onPressed: () => _startContainer(container),
              ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.orange),
              onPressed: () => _restartContainer(container),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildResourceRow('CPU Usage', container.cpuUsage, Colors.cyan),
                const SizedBox(height: 8),
                _buildResourceRow('Memory Usage', container.memoryUsage / 1024, Colors.green),
                const SizedBox(height: 8),
                Text('Uptime: ${container.uptime}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceRow(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text('${value.toStringAsFixed(1)}${label.contains('CPU') ? '%' : ' MB'}', style: TextStyle(color: color)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / (label.contains('CPU') ? 100 : 1024),
          backgroundColor: Colors.grey.shade800,
          color: color,
        ),
      ],
    );
  }

  Widget _buildImagesTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImageStat('Total Images', '${_images.length}', Colors.blue),
              _buildImageStat('Total Size', '${_totalImageSize.toStringAsFixed(1)} GB', Colors.orange),
              _buildImageStat('Avg Size', '${(_totalImageSize / _images.length).toStringAsFixed(1)} GB', Colors.green),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _images.length,
            itemBuilder: (ctx, i) {
              final image = _images[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(image.icon, color: image.color),
                  title: Text(image.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${image.size} • Created: ${image.created}', style: const TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeImage(image),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildAppsTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAppStat('Installed', '${_installedApps.length}', Colors.blue),
              _buildAppStat('Running', '${_runningApps.length}', Colors.green),
              _buildAppStat('Stopped', '${_installedApps.length - _runningApps.length}', Colors.red),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _installedApps.length,
            itemBuilder: (ctx, i) {
              final app = _installedApps[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(app.icon, color: app.color),
                  title: Text(app.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Version ${app.version} • ${app.memory} MB', style: const TextStyle(color: Colors.grey)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (app.status == 'Running')
                        const Icon(Icons.play_circle, color: Colors.green),
                      if (app.status == 'Stopped')
                        const Icon(Icons.stop_circle, color: Colors.red),
                      const SizedBox(width: 8),
                      Switch(
                        value: app.status == 'Running',
                        onChanged: (_) {
                          setState(() {
                            if (app.status == 'Running') {
                              app.status = 'Stopped';
                              _runningApps.remove(app);
                            } else {
                              app.status = 'Running';
                              _runningApps.add(app);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
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
              children: [
                const Text('Container Resource Usage', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                ..._containerResources.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(entry.key, style: const TextStyle(color: Colors.white)),
                          const Spacer(),
                          Text('${entry.value.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.cyan)),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: entry.value / 100,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.cyan,
                      ),
                    ],
                  ),
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
                const Text('System Resources', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildSystemResource('Total CPU', '8 Cores', Colors.blue),
                _buildSystemResource('Total Memory', '16 GB', Colors.green),
                _buildSystemResource('Container Storage', '45 GB', Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemResource(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class Container {
  final String name;
  String status;
  final String image;
  final String size;
  final String uptime;
  final IconData icon;
  final Color color;
  double cpuUsage;
  int memoryUsage;

  Container(this.name, this.status, this.image, this.size, this.uptime, this.icon, this.color, this.cpuUsage, this.memoryUsage);
}

class Image {
  final String name;
  final String size;
  final String created;
  final IconData icon;
  final Color color;

  Image(this.name, this.size, this.created, this.icon, this.color);
}

class App {
  final String name;
  final String version;
  String status;
  final IconData icon;
  final Color color;
  final int memory;

  App(this.name, this.version, this.status, this.icon, this.color, this.memory);
}
