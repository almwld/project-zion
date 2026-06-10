import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class ARCenter extends StatefulWidget {
  const ARCenter({super.key});

  @override
  State<ARCenter> createState() => _ARCenterState();
}

class _ARCenterState extends State<ARCenter> {
  int _selectedTab = 0;
  
  // 3D Network Visualization
  List<NetworkNode> _networkNodes = [];
  List<NetworkConnection> _connections = [];
  bool _is3DMode = true;
  double _rotationX = 0;
  double _rotationY = 0;
  
  // Security Heatmap
  List<SecurityZone> _securityZones = [];
  double _selectedTime = 0;
  
  // Threat Intelligence
  List<ThreatIntelligence> _threats = [];
  List<Anomaly> _anomalies = [];
  
  // Data Dashboard
  List<DashboardMetric> _metrics = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initNetworkVisualization();
    _initSecurityHeatmap();
    _initThreatIntelligence();
    _initDashboard();
    _startAutoRefresh();
  }

  void _initNetworkVisualization() {
    _networkNodes = [
      NetworkNode('Gateway', 0.5, 0.5, Colors.red, 30),
      NetworkNode('Server A', 0.3, 0.3, Colors.green, 20),
      NetworkNode('Server B', 0.7, 0.3, Colors.green, 20),
      NetworkNode('Workstation 1', 0.2, 0.7, Colors.blue, 15),
      NetworkNode('Workstation 2', 0.8, 0.7, Colors.blue, 15),
      NetworkNode('Database', 0.5, 0.2, Colors.orange, 25),
      NetworkNode('Firewall', 0.5, 0.85, Colors.red, 18),
    ];
    
    _connections = [
      NetworkConnection(0, 1, 85),
      NetworkConnection(0, 2, 85),
      NetworkConnection(0, 6, 95),
      NetworkConnection(1, 3, 70),
      NetworkConnection(2, 4, 70),
      NetworkConnection(1, 5, 90),
      NetworkConnection(2, 5, 90),
      NetworkConnection(3, 6, 60),
      NetworkConnection(4, 6, 60),
    ];
  }

  void _initSecurityHeatmap() {
    _securityZones = [
      SecurityZone('DMZ', 0.1, 0.1, 0.3, 0.2, 0.9, 'Critical'),
      SecurityZone('Internal Network', 0.4, 0.1, 0.5, 0.5, 0.4, 'Medium'),
      SecurityZone('Database Zone', 0.4, 0.6, 0.5, 0.3, 0.8, 'High'),
      SecurityZone('User Network', 0.1, 0.4, 0.2, 0.5, 0.3, 'Low'),
      SecurityZone('Management', 0.7, 0.4, 0.2, 0.4, 0.6, 'High'),
    ];
  }

  void _initThreatIntelligence() {
    _threats = [
      ThreatIntelligence('Port Scan', '192.168.1.105', 'High', DateTime.now().subtract(const Duration(minutes: 5)), 85),
      ThreatIntelligence('Brute Force', '10.0.0.25', 'Critical', DateTime.now().subtract(const Duration(minutes: 12)), 95),
      ThreatIntelligence('Malware', '192.168.1.50', 'Medium', DateTime.now().subtract(const Duration(minutes: 30)), 65),
      ThreatIntelligence('DoS Attack', '8.8.8.8', 'High', DateTime.now().subtract(const Duration(minutes: 45)), 78),
      ThreatIntelligence('Data Exfiltration', '10.0.0.100', 'Critical', DateTime.now().subtract(const Duration(hours: 1)), 92),
    ];
    
    _anomalies = [
      Anomaly('Unusual Traffic Spike', 'Network', 0.95, DateTime.now().subtract(const Duration(minutes: 8))),
      Anomaly('Multiple Failed Logins', 'Authentication', 0.88, DateTime.now().subtract(const Duration(minutes: 15))),
      Anomaly('New Device Connected', 'Asset', 0.75, DateTime.now().subtract(const Duration(minutes: 22))),
      Anomaly('Suspicious Process', 'Endpoint', 0.82, DateTime.now().subtract(const Duration(minutes: 35))),
    ];
  }

  void _initDashboard() {
    _metrics = [
      DashboardMetric('Network Traffic', '125 Mbps', '↑ 15%', Colors.cyan, 0.65),
      DashboardMetric('Active Threats', '23', '↑ 3', Colors.red, 0.45),
      DashboardMetric('System Load', '42%', '↓ 5%', Colors.green, 0.42),
      DashboardMetric('Storage Used', '234 GB', '↑ 12 GB', Colors.orange, 0.58),
      DashboardMetric('API Calls', '1,234', '↑ 234', Colors.purple, 0.72),
      DashboardMetric('Users Online', '156', '↓ 12', Colors.blue, 0.63),
    ];
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        // Update metrics
        final random = Random();
        setState(() {
          for (var metric in _metrics) {
            final change = (random.nextDouble() - 0.5) * 0.1;
            metric.value = (metric.value + change).clamp(0.0, 1.0);
          }
        });
      }
    });
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
        title: const Text('AR & Visualization Center'),
        backgroundColor: Colors.purple.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.network_check), text: '3D Network'),
            Tab(icon: Icon(Icons.heat_pump), text: 'Heatmap'),
            Tab(icon: Icon(Icons.psychology), text: 'Threat Intel'),
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _build3DNetwork(),
          _buildSecurityHeatmap(),
          _buildThreatIntelligence(),
          _buildDataDashboard(),
        ],
      ),
    );
  }

  Widget _build3DNetwork() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.rotate_left),
                onPressed: () => setState(() => _rotationY -= 0.1),
              ),
              Switch(
                value: _is3DMode,
                onChanged: (v) => setState(() => _is3DMode = v),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: () => setState(() => _rotationY += 0.1),
              ),
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
              painter: NetworkPainter(_networkNodes, _connections, _rotationX, _rotationY, _is3DMode),
              size: Size.infinite,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegend('Gateway', Colors.red),
              _buildLegend('Server', Colors.green),
              _buildLegend('Workstation', Colors.blue),
              _buildLegend('Database', Colors.orange),
              _buildLegend('Firewall', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildSecurityHeatmap() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Time:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: _selectedTime,
                  onChanged: (v) => setState(() => _selectedTime = v),
                ),
              ),
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
              painter: HeatmapPainter(_securityZones, _selectedTime),
              size: Size.infinite,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeatmapLegend('Low Risk', Colors.green),
              _buildHeatmapLegend('Medium Risk', Colors.yellow),
              _buildHeatmapLegend('High Risk', Colors.orange),
              _buildHeatmapLegend('Critical', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildThreatIntelligence() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade900,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.warning), text: 'Active Threats'),
                Tab(icon: Icon(Icons.analytics), text: 'Anomalies'),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: _threats.length,
                  itemBuilder: (ctx, i) {
                    final threat = _threats[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(left: BorderSide(color: threat.severity == 'Critical' ? Colors.red : threat.severity == 'High' ? Colors.orange : Colors.yellow, width: 4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(threat.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: threat.severity == 'Critical' ? Colors.red.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(threat.severity, style: TextStyle(color: threat.severity == 'Critical' ? Colors.red : Colors.orange, fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Source: ${threat.source}', style: const TextStyle(color: Colors.grey)),
                          Text('Confidence: ${threat.confidence}%', style: const TextStyle(color: Colors.white70)),
                          Text('Detected: ${_formatTime(threat.time)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: _anomalies.length,
                  itemBuilder: (ctx, i) {
                    final anomaly = _anomalies[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.warning, color: Colors.orange),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(anomaly.name, style: const TextStyle(color: Colors.white)),
                                Text('${anomaly.category} • Score: ${(anomaly.score * 100).toInt()}%', style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(_formatTime(anomaly.time), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
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

  Widget _buildDataDashboard() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _metrics.length,
      itemBuilder: (ctx, i) {
        final metric = _metrics[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: metric.color, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(metric.getIcon(), color: metric.color, size: 32),
              const SizedBox(height: 12),
              Text(metric.valueText, style: TextStyle(color: metric.color, fontSize: 24, fontWeight: FontWeight.bold)),
              Text(metric.label, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(metric.change, style: TextStyle(color: metric.change.contains('↑') ? Colors.green : Colors.red, fontSize: 12)),
              LinearProgressIndicator(
                value: metric.value,
                backgroundColor: Colors.grey.shade800,
                color: metric.color,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    return '${diff.inHours} hours ago';
  }
}

class NetworkNode {
  final String name;
  final double x;
  final double y;
  final Color color;
  final int size;

  NetworkNode(this.name, this.x, this.y, this.color, this.size);
}

class NetworkConnection {
  final int from;
  final int to;
  final int bandwidth;

  NetworkConnection(this.from, this.to, this.bandwidth);
}

class SecurityZone {
  final String name;
  final double x;
  final double y;
  final double width;
  final double height;
  final double risk;
  final String severity;

  SecurityZone(this.name, this.x, this.y, this.width, this.height, this.risk, this.severity);
}

class ThreatIntelligence {
  final String name;
  final String source;
  final String severity;
  final DateTime time;
  final int confidence;

  ThreatIntelligence(this.name, this.source, this.severity, this.time, this.confidence);
}

class Anomaly {
  final String name;
  final String category;
  final double score;
  final DateTime time;

  Anomaly(this.name, this.category, this.score, this.time);
}

class DashboardMetric {
  final String label;
  final String valueText;
  final String change;
  final Color color;
  double value;

  DashboardMetric(this.label, this.valueText, this.change, this.color, this.value);

  IconData getIcon() {
    if (label.contains('Traffic')) return Icons.network_check;
    if (label.contains('Threats')) return Icons.warning;
    if (label.contains('Load')) return Icons.speed;
    if (label.contains('Storage')) return Icons.storage;
    if (label.contains('API')) return Icons.api;
    return Icons.people;
  }
}

class NetworkPainter extends CustomPainter {
  final List<NetworkNode> nodes;
  final List<NetworkConnection> connections;
  final double rotationX;
  final double rotationY;
  final bool is3D;

  NetworkPainter(this.nodes, this.connections, this.rotationX, this.rotationY, this.is3D);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.cyan.withOpacity(0.3)..strokeWidth = 2;
    
    for (final conn in connections) {
      final from = nodes[conn.from];
      final to = nodes[conn.to];
      final fromX = from.x * size.width;
      final fromY = from.y * size.height;
      final toX = to.x * size.width;
      final toY = to.y * size.height;
      canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), paint);
    }
    
    for (final node in nodes) {
      final x = node.x * size.width;
      final y = node.y * size.height;
      final paint2 = Paint()..color = node.color;
      canvas.drawCircle(Offset(x, y), node.size.toDouble(), paint2);
      
      final textPainter = TextPainter(
        text: TextSpan(text: node.name, style: const TextStyle(color: Colors.white, fontSize: 10)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - node.size - 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HeatmapPainter extends CustomPainter {
  final List<SecurityZone> zones;
  final double time;

  HeatmapPainter(this.zones, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    for (final zone in zones) {
      final x = zone.x * size.width;
      final y = zone.y * size.height;
      final w = zone.width * size.width;
      final h = zone.height * size.height;
      
      Color color;
      if (zone.severity == 'Critical') color = Colors.red.withOpacity(0.7);
      else if (zone.severity == 'High') color = Colors.orange.withOpacity(0.6);
      else if (zone.severity == 'Medium') color = Colors.yellow.withOpacity(0.5);
      else color = Colors.green.withOpacity(0.4);
      
      final paint = Paint()..color = color;
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
      
      final textPainter = TextPainter(
        text: TextSpan(text: zone.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + 5, y + 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
