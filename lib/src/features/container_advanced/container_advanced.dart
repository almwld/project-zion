import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ContainerAdvancedCenter extends StatefulWidget {
  const ContainerAdvancedCenter({super.key});

  @override
  State<ContainerAdvancedCenter> createState() => _ContainerAdvancedCenterState();
}

class _ContainerAdvancedCenterState extends State<ContainerAdvancedCenter> {
  int _selectedTab = 0;
  
  // Docker Containers
  List<DockerContainer> _containers = [];
  List<DockerContainer> _runningContainers = [];
  List<DockerContainer> _stoppedContainers = [];
  
  // Docker Images
  List<DockerImage> _images = [];
  int _totalImages = 0;
  int _totalSize = 0;
  
  // Docker Compose
  List<ComposeProject> _composeProjects = [];
  List<ComposeService> _composeServices = [];
  
  // Podman (بديل Docker)
  List<PodmanContainer> _podmanContainers = [];
  bool _podmanEnabled = true;
  
  // Kubernetes
  List<K8sPod> _k8sPods = [];
  List<K8sService> _k8sServices = [];
  List<K8sDeployment> _k8sDeployments = [];

  @override
  void initState() {
    super.initState();
    _loadContainers();
    _loadImages();
    _loadComposeProjects();
    _loadPodmanContainers();
    _loadK8sResources();
    _startContainerMonitoring();
  }

  void _loadContainers() {
    _containers = [
      DockerContainer('nginx-web', 'nginx:alpine', 'Running', 45, 128, '2 hours', Icons.web, Colors.blue),
      DockerContainer('postgres-db', 'postgres:15', 'Running', 12, 512, '5 hours', Icons.storage, Colors.cyan),
      DockerContainer('redis-cache', 'redis:7', 'Stopped', 0, 0, '1 day', Icons.speed, Colors.red),
      DockerContainer('app-backend', 'node:18', 'Running', 28, 256, '30 min', Icons.code, Colors.green),
    ];
    
    _runningContainers = _containers.where((c) => c.status == 'Running').toList();
    _stoppedContainers = _containers.where((c) => c.status == 'Stopped').toList();
  }

  void _loadImages() {
    _images = [
      DockerImage('nginx', 'alpine', '45 MB', '2 weeks ago', Icons.web, Colors.blue),
      DockerImage('postgres', '15', '180 MB', '1 week ago', Icons.storage, Colors.cyan),
      DockerImage('redis', '7', '35 MB', '3 days ago', Icons.speed, Colors.red),
      DockerImage('node', '18', '320 MB', '1 day ago', Icons.code, Colors.green),
    ];
    _totalImages = _images.length;
    _totalSize = 580;
  }

  void _loadComposeProjects() {
    _composeProjects = [
      ComposeProject('web-app', 'docker-compose.yml', 'Running', 3, Icons.web, Colors.blue),
      ComposeProject('database-cluster', 'docker-compose.db.yml', 'Stopped', 2, Icons.storage, Colors.cyan),
    ];
    
    _composeServices = [
      ComposeService('web', 'nginx:alpine', 'Running', 'web-app', Icons.web, Colors.blue),
      ComposeService('api', 'node:18', 'Running', 'web-app', Icons.code, Colors.green),
      ComposeService('db', 'postgres:15', 'Running', 'web-app', Icons.storage, Colors.cyan),
    ];
  }

  void _loadPodmanContainers() {
    _podmanContainers = [
      PodmanContainer('podman-web', 'nginx:alpine', 'Running', 38, 96, Icons.web, Colors.blue),
      PodmanContainer('podman-db', 'postgres:15', 'Stopped', 0, 0, Icons.storage, Colors.cyan),
    ];
  }

  void _loadK8sResources() {
    _k8sPods = [
      K8sPod('nginx-pod', 'Running', '10.0.0.1', 'node-1', 1, 45, Icons.web, Colors.blue),
      K8sPod('api-pod', 'Running', '10.0.0.2', 'node-1', 2, 128, Icons.code, Colors.green),
    ];
    
    _k8sServices = [
      K8sService('nginx-svc', 'ClusterIP', '10.96.0.1', 80, Icons.web, Colors.blue),
      K8sService('api-svc', 'LoadBalancer', '10.96.0.2', 8080, Icons.code, Colors.green),
    ];
    
    _k8sDeployments = [
      K8sDeployment('nginx-deploy', 3, 3, 'nginx:alpine', Icons.web, Colors.blue),
      K8sDeployment('api-deploy', 2, 2, 'node:18', Icons.code, Colors.green),
    ];
  }

  void _startContainerMonitoring() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          for (var container in _runningContainers) {
            container.cpu = (container.cpu + (random.nextInt(10) - 5)).clamp(0, 100);
            container.memory = (container.memory + (random.nextInt(50) - 25)).clamp(0, 1024);
          }
        });
      }
    });
  }

  void _startContainer(DockerContainer container) {
    setState(() {
      container.status = 'Running';
      _runningContainers.add(container);
      _stoppedContainers.remove(container);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Started: ${container.name}')),
    );
  }

  void _stopContainer(DockerContainer container) {
    setState(() {
      container.status = 'Stopped';
      _stoppedContainers.add(container);
      _runningContainers.remove(container);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stopped: ${container.name}')),
    );
  }

  void _removeImage(DockerImage image) {
    setState(() {
      _images.remove(image);
      _totalImages--;
      _totalSize -= int.parse(image.size.split(' ')[0]);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed: ${image.name}')),
    );
  }

  void _pullImage() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pull Image'),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Image Name (e.g., nginx:alpine)'),
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan), child: const Text('Pull')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Container Advanced'),
        backgroundColor: Colors.cyan.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Containers'),
            Tab(icon: Icon(Icons.image), text: 'Images'),
            Tab(icon: Icon(Icons.developer_board), text: 'Compose'),
            Tab(icon: Icon(Icons.abc), text: 'Podman'),
            Tab(icon: Icon(Icons.cloud_circle), text: 'K8s'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildContainersTab(),
          _buildImagesTab(),
          _buildComposeTab(),
          _buildPodmanTab(),
          _buildK8sTab(),
        ],
      ),
    );
  }

  Widget _buildContainersTab() {
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
              _buildContainerStat('Total', '${_containers.length}', Colors.blue),
              _buildContainerStat('Running', '${_runningContainers.length}', Colors.green),
              _buildContainerStat('Stopped', '${_stoppedContainers.length}', Colors.red),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _containers.length,
            itemBuilder: (ctx, i) {
              final container = _containers[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ExpansionTile(
                  leading: Icon(container.icon, color: container.color),
                  title: Text(container.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(container.image, style: const TextStyle(color: Colors.grey)),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: container.status == 'Running' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(container.status, style: TextStyle(color: container.status == 'Running' ? Colors.green : Colors.red)),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildResourceRow('CPU', container.cpu, Colors.cyan),
                          const SizedBox(height: 8),
                          _buildResourceRow('Memory', container.memory, Colors.green),
                          const SizedBox(height: 8),
                          Text('Uptime: ${container.uptime}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
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

  Widget _buildContainerStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildResourceRow(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text('${value}%', style: TextStyle(color: color)),
          ],
        ),
        LinearProgressIndicator(
          value: value / 100,
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
              _buildImageStat('Images', '$_totalImages', Colors.blue),
              _buildImageStat('Total Size', '${_totalSize} MB', Colors.orange),
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
                  title: Text('${image.name}:${image.tag}', style: const TextStyle(color: Colors.white)),
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
        Container(
          margin: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _pullImage,
            icon: const Icon(Icons.download),
            label: const Text('PULL IMAGE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              minimumSize: const Size(double.infinity, 45),
            ),
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

  Widget _buildComposeTab() {
    return Column(
      children: [
        ..._composeProjects.map((project) => Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.all(16),
          child: ExpansionTile(
            leading: Icon(project.icon, color: project.color),
            title: Text(project.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${project.services} services • ${project.status}', style: const TextStyle(color: Colors.grey)),
            children: _composeServices
                .where((s) => s.project == project.name)
                .map((service) => ListTile(
                  leading: Icon(service.icon, color: service.color),
                  title: Text(service.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(service.image, style: const TextStyle(color: Colors.grey)),
                  trailing: Text(service.status, style: const TextStyle(color: Colors.green)),
                ))
                .toList(),
          ),
        )),
      ],
    );
  }

  Widget _buildPodmanTab() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Podman Enabled', style: TextStyle(color: Colors.white)),
          subtitle: const Text('Use Podman as Docker alternative', style: TextStyle(color: Colors.grey)),
          value: _podmanEnabled,
          onChanged: (v) => setState(() => _podmanEnabled = v),
          secondary: const Icon(Icons.abc, color: Colors.cyan),
        ),
        ..._podmanContainers.map((container) => Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.all(16),
          child: ListTile(
            leading: Icon(container.icon, color: container.color),
            title: Text(container.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('CPU: ${container.cpu}% • Memory: ${container.memory} MB', style: const TextStyle(color: Colors.grey)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: container.status == 'Running' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(container.status, style: TextStyle(color: container.status == 'Running' ? Colors.green : Colors.red)),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildK8sTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade900,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.view_module), text: 'Pods'),
                Tab(icon: Icon(Icons.route), text: 'Services'),
                Tab(icon: Icon(Icons.developer_board), text: 'Deployments'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: _k8sPods.length,
                  itemBuilder: (ctx, i) {
                    final pod = _k8sPods[i];
                    return Card(
                      color: Colors.grey.shade900,
                      margin: const EdgeInsets.all(16),
                      child: ListTile(
                        leading: Icon(pod.icon, color: pod.color),
                        title: Text(pod.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('IP: ${pod.ip} • Node: ${pod.node} • CPU: ${pod.cpu}%', style: const TextStyle(color: Colors.grey)),
                        trailing: Text(pod.status, style: const TextStyle(color: Colors.green)),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: _k8sServices.length,
                  itemBuilder: (ctx, i) {
                    final svc = _k8sServices[i];
                    return Card(
                      color: Colors.grey.shade900,
                      margin: const EdgeInsets.all(16),
                      child: ListTile(
                        leading: Icon(svc.icon, color: svc.color),
                        title: Text(svc.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('Type: ${svc.type} • ClusterIP: ${svc.clusterIP} • Port: ${svc.port}', style: const TextStyle(color: Colors.grey)),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: _k8sDeployments.length,
                  itemBuilder: (ctx, i) {
                    const dep = _k8sDeployments[i];
                    return Card(
                      color: Colors.grey.shade900,
                      margin: const EdgeInsets.all(16),
                      child: ListTile(
                        leading: Icon(dep.icon, color: dep.color),
                        title: Text(dep.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('Replicas: ${dep.ready}/${dep.desired} • Image: ${dep.image}', style: const TextStyle(color: Colors.grey)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DockerContainer {
  final String name;
  final String image;
  String status;
  int cpu;
  int memory;
  final String uptime;
  final IconData icon;
  final Color color;

  DockerContainer(this.name, this.image, this.status, this.cpu, this.memory, this.uptime, this.icon, this.color);
}

class DockerImage {
  final String name;
  final String tag;
  final String size;
  final String created;
  final IconData icon;
  final Color color;

  DockerImage(this.name, this.tag, this.size, this.created, this.icon, this.color);
}

class ComposeProject {
  final String name;
  final String file;
  final String status;
  final int services;
  final IconData icon;
  final Color color;

  ComposeProject(this.name, this.file, this.status, this.services, this.icon, this.color);
}

class ComposeService {
  final String name;
  final String image;
  final String status;
  final String project;
  final IconData icon;
  final Color color;

  ComposeService(this.name, this.image, this.status, this.project, this.icon, this.color);
}

class PodmanContainer {
  final String name;
  final String image;
  final String status;
  final int cpu;
  final int memory;
  final IconData icon;
  final Color color;

  PodmanContainer(this.name, this.image, this.status, this.cpu, this.memory, this.icon, this.color);
}

class K8sPod {
  final String name;
  final String status;
  final String ip;
  final String node;
  final int containers;
  final int cpu;
  final IconData icon;
  final Color color;

  K8sPod(this.name, this.status, this.ip, this.node, this.containers, this.cpu, this.icon, this.color);
}

class K8sService {
  final String name;
  final String type;
  final String clusterIP;
  final int port;
  final IconData icon;
  final Color color;

  K8sService(this.name, this.type, this.clusterIP, this.port, this.icon, this.color);
}

class K8sDeployment {
  final String name;
  final int desired;
  final int ready;
  final String image;
  final IconData icon;
  final Color color;

  K8sDeployment(this.name, this.desired, this.ready, this.image, this.icon, this.color);
}
