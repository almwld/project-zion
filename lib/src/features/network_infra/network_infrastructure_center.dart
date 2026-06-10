import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class NetworkInfrastructureCenter extends StatefulWidget {
  const NetworkInfrastructureCenter({super.key});

  @override
  State<NetworkInfrastructureCenter> createState() => _NetworkInfrastructureCenterState();
}

class _NetworkInfrastructureCenterState extends State<NetworkInfrastructureCenter> {
  int _selectedTab = 0;
  
  // Network Topology
  List<NetworkNode> _nodes = [];
  List<NetworkLink> _links = [];
  double _networkHealth = 0;
  
  // Bandwidth Monitoring
  Map<String, double> _bandwidthUsage = {};
  List<BandwidthHistory> _bandwidthHistory = [];
  
  // Device Management
  List<NetworkDevice> _devices = [];
  int _totalDevices = 0;
  int _activeDevices = 0;
  
  // Network Security
  List<SecurityThreat> _threats = [];
  int _blockedAttacks = 0;
  double _securityScore = 0;

  @override
  void initState() {
    super.initState();
    _initTopology();
    _initBandwidth();
    _initDevices();
    _initSecurity();
    _startMonitoring();
  }

  void _initTopology() {
    _nodes = [
      NetworkNode('Gateway', 0.5, 0.1, Colors.red, true),
      NetworkNode('Core Switch', 0.5, 0.3, Colors.orange, false),
      NetworkNode('Server A', 0.2, 0.6, Colors.green, false),
      NetworkNode('Server B', 0.8, 0.6, Colors.green, false),
      NetworkNode('Workstation 1', 0.1, 0.85, Colors.blue, false),
      NetworkNode('Workstation 2', 0.9, 0.85, Colors.blue, false),
      NetworkNode('Database', 0.5, 0.5, Colors.purple, false),
    ];
    
    _links = [
      NetworkLink(0, 1, 1000),
      NetworkLink(1, 2, 100),
      NetworkLink(1, 3, 100),
      NetworkLink(1, 6, 1000),
      NetworkLink(2, 4, 100),
      NetworkLink(3, 5, 100),
    ];
    
    _networkHealth = 98.5;
  }

  void _initBandwidth() {
    _bandwidthUsage = {
      'Gateway': 45.5,
      'Core Switch': 62.3,
      'Server A': 28.7,
      'Server B': 34.2,
      'Database': 78.9,
    };
    
    for (int i = 0; i < 20; i++) {
      _bandwidthHistory.add(BandwidthHistory(DateTime.now().subtract(Duration(minutes: 20 - i)), 30 + Random().nextDouble() * 60));
    }
  }

  void _initDevices() {
    _devices = [
      NetworkDevice('Gateway Router', '192.168.1.1', 'Online', 'Cisco', '98%'),
      NetworkDevice('Core Switch', '192.168.1.2', 'Online', 'Juniper', '95%'),
      NetworkDevice('Server A', '192.168.1.10', 'Online', 'Dell', '99%'),
      NetworkDevice('Server B', '192.168.1.11', 'Online', 'HP', '97%'),
      NetworkDevice('Workstation 1', '192.168.1.100', 'Offline', 'Dell', '0%'),
      NetworkDevice('Workstation 2', '192.168.1.101', 'Online', 'Lenovo', '96%'),
    ];
    _totalDevices = _devices.length;
    _activeDevices = _devices.where((d) => d.status == 'Online').length;
  }

  void _initSecurity() {
    _threats = [
      SecurityThreat('Port Scan', '192.168.1.105', 'Medium', DateTime.now().subtract(const Duration(minutes: 5)), 'Blocked'),
      SecurityThreat('DoS Attack', '10.0.0.25', 'High', DateTime.now().subtract(const Duration(minutes: 15)), 'Blocked'),
      SecurityThreat('Malware Detection', '192.168.1.50', 'Critical', DateTime.now().subtract(const Duration(hours: 1)), 'Quarantined'),
    ];
    _blockedAttacks = 234;
    _securityScore = 87.5;
  }

  void _startMonitoring() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        for (var key in _bandwidthUsage.keys) {
          _bandwidthUsage[key] = (30 + random.nextDouble() * 70).clamp(0.0, 100.0);
        }
        
        _bandwidthHistory.add(BandwidthHistory(DateTime.now(), 30 + random.nextDouble() * 70));
        if (_bandwidthHistory.length > 20) _bandwidthHistory.removeAt(0);
        
        _networkHealth = (90 + random.nextDouble() * 9).clamp(0.0, 100.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Network Infrastructure'),
        backgroundColor: Colors.blueGrey.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.device_hub), text: 'Topology'),
            Tab(icon: Icon(Icons.speed), text: 'Bandwidth'),
            Tab(icon: Icon(Icons.devices), text: 'Devices'),
            Tab(icon: Icon(Icons.security), text: 'Security'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildTopologyTab(),
          _buildBandwidthTab(),
          _buildDevicesTab(),
          _buildSecurityTab(),
        ],
      ),
    );
  }

  Widget _buildTopologyTab() {
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
              _buildTopologyStat('Network Health', '${_networkHealth.toStringAsFixed(1)}%', Colors.green),
              _buildTopologyStat('Nodes', '${_nodes.length}', Colors.cyan),
              _buildTopologyStat('Links', '${_links.length}', Colors.orange),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomPaint(
              painter: TopologyPainter(_nodes, _links),
              size: Size.infinite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopologyStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildBandwidthTab() {
    final maxBandwidth = _bandwidthHistory.map((h) => h.value).reduce((a, b) => a > b ? a : b);
    
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
              const Text('Current Bandwidth Usage', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),
              ..._bandwidthUsage.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(width: 100, child: Text(entry.key, style: const TextStyle(color: Colors.white))),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: entry.value / 100,
                        backgroundColor: Colors.grey.shade800,
                        color: entry.value > 80 ? Colors.red : entry.value > 60 ? Colors.orange : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${entry.value.toStringAsFixed(1)} Mbps', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              )),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('Bandwidth History', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _bandwidthHistory.length,
                  itemBuilder: (ctx, i) {
                    final item = _bandwidthHistory[i];
                    final height = (item.value / maxBandwidth) * 120;
                    return Container(
                      width: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                color: item.value > 80 ? Colors.red : item.value > 60 ? Colors.orange : Colors.cyan,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${item.time.minute}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDevicesTab() {
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
              _buildDeviceStat('Total Devices', '$_totalDevices', Colors.blue),
              _buildDeviceStat('Active', '$_activeDevices', Colors.green),
              _buildDeviceStat('Offline', '${_totalDevices - _activeDevices}', Colors.red),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (ctx, i) {
              final device = _devices[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: device.status == 'Online' ? Colors.green : Colors.red, width: 4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.devices, color: device.status == 'Online' ? Colors.green : Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(device.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('${device.ip} • ${device.vendor}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(device.status, style: TextStyle(color: device.status == 'Online' ? Colors.green : Colors.red)),
                        Text('Uptime: ${device.uptime}', style: const TextStyle(color: Colors.grey)),
                      ],
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

  Widget _buildDeviceStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildSecurityTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade900, Colors.black],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Security Score', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _securityScore / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.green,
                    ),
                  ),
                  Text('${_securityScore.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Blocked Attacks: $_blockedAttacks', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _threats.length,
            itemBuilder: (ctx, i) {
              final threat = _threats[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: threat.severity == 'Critical' ? Colors.red : threat.severity == 'High' ? Colors.orange : Colors.yellow, width: 4)),
                ),
                child: Row(
                  children: [
                    Icon(
                      threat.severity == 'Critical' ? Icons.error :
                      threat.severity == 'High' ? Icons.warning : Icons.info,
                      color: threat.severity == 'Critical' ? Colors.red : threat.severity == 'High' ? Colors.orange : Colors.yellow,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(threat.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Source: ${threat.source} • Status: ${threat.status}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(_formatTime(threat.time), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class NetworkNode {
  final String name;
  final double x;
  final double y;
  final Color color;
  final bool isGateway;

  NetworkNode(this.name, this.x, this.y, this.color, this.isGateway);
}

class NetworkLink {
  final int from;
  final int to;
  final int bandwidth;

  NetworkLink(this.from, this.to, this.bandwidth);
}

class BandwidthHistory {
  final DateTime time;
  final double value;

  BandwidthHistory(this.time, this.value);
}

class NetworkDevice {
  final String name;
  final String ip;
  final String status;
  final String vendor;
  final String uptime;

  NetworkDevice(this.name, this.ip, this.status, this.vendor, this.uptime);
}

class SecurityThreat {
  final String name;
  final String source;
  final String severity;
  final DateTime time;
  final String status;

  SecurityThreat(this.name, this.source, this.severity, this.time, this.status);
}

class TopologyPainter extends CustomPainter {
  final List<NetworkNode> nodes;
  final List<NetworkLink> links;

  TopologyPainter(this.nodes, this.links);

  @override
  void paint(Canvas canvas, Size size) {
    final linkPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..strokeWidth = 2;
    
    for (final link in links) {
      final from = nodes[link.from];
      final to = nodes[link.to];
      final fromX = from.x * size.width;
      final fromY = from.y * size.height;
      final toX = to.x * size.width;
      final toY = to.y * size.height;
      canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), linkPaint);
    }
    
    for (final node in nodes) {
      final x = node.x * size.width;
      final y = node.y * size.height;
      final nodePaint = Paint()
        ..color = node.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), node.isGateway ? 20 : 15, nodePaint);
      
      final textPainter = TextPainter(
        text: TextSpan(text: node.name, style: const TextStyle(color: Colors.white, fontSize: 10)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 25));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
