import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SimulationCenter extends StatefulWidget {
  const SimulationCenter({super.key});

  @override
  State<SimulationCenter> createState() => _SimulationCenterState();
}

class _SimulationCenterState extends State<SimulationCenter> {
  int _selectedSimulation = 0;
  
  // Network Simulation
  bool _isNetworkSimRunning = false;
  Timer? _networkTimer;
  List<NetworkPacket> _networkPackets = [];
  int _packetCount = 0;
  int _totalBytes = 0;
  
  // Attack Simulation
  bool _isAttackSimRunning = false;
  Timer? _attackTimer;
  List<SimulatedAttack> _simulatedAttacks = [];
  int _successfulAttacks = 0;
  int _failedAttacks = 0;
  
  // Load Testing
  bool _isLoadTestRunning = false;
  Timer? _loadTimer;
  double _cpuLoad = 0;
  double _memoryLoad = 0;
  double _networkLoad = 0;
  List<double> _loadHistory = [];
  
  // Vulnerability Scanner
  bool _isVulnScanRunning = false;
  List<Vulnerability> _vulnerabilities = [];
  int _totalScanned = 0;
  int _criticalFound = 0;
  int _highFound = 0;
  int _mediumFound = 0;

  @override
  void initState() {
    super.initState();
    _initLoadHistory();
  }

  void _initLoadHistory() {
    for (int i = 0; i < 20; i++) {
      _loadHistory.add(0);
    }
  }

  // ==================== Network Simulation ====================
  void _startNetworkSimulation() {
    setState(() {
      _isNetworkSimRunning = true;
      _networkPackets.clear();
      _packetCount = 0;
      _totalBytes = 0;
    });
    
    _networkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final random = Random();
      final packet = NetworkPacket(
        id: _packetCount + 1,
        source: '192.168.1.${random.nextInt(254) + 1}',
        destination: '10.0.0.${random.nextInt(254) + 1}',
        size: random.nextInt(1400) + 100,
        protocol: ['TCP', 'UDP', 'ICMP', 'HTTP'][random.nextInt(4)],
        timestamp: DateTime.now(),
      );
      
      setState(() {
        _networkPackets.insert(0, packet);
        if (_networkPackets.length > 50) _networkPackets.removeLast();
        _packetCount++;
        _totalBytes += packet.size;
      });
    });
  }

  void _stopNetworkSimulation() {
    _networkTimer?.cancel();
    setState(() => _isNetworkSimRunning = false);
  }

  // ==================== Attack Simulation ====================
  void _startAttackSimulation() {
    setState(() {
      _isAttackSimRunning = true;
      _simulatedAttacks.clear();
      _successfulAttacks = 0;
      _failedAttacks = 0;
    });
    
    _attackTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final random = Random();
      final success = random.nextDouble() > 0.3;
      final attack = SimulatedAttack(
        id: _simulatedAttacks.length + 1,
        type: ['Port Scan', 'Brute Force', 'SQL Injection', 'DoS', 'MITM'][random.nextInt(5)],
        target: '192.168.1.${random.nextInt(254) + 1}',
        success: success,
        timestamp: DateTime.now(),
        details: success ? 'Vulnerability exploited successfully' : 'Attack blocked by firewall',
      );
      
      setState(() {
        _simulatedAttacks.insert(0, attack);
        if (_simulatedAttacks.length > 50) _simulatedAttacks.removeLast();
        if (success) _successfulAttacks++;
        else _failedAttacks++;
      });
    });
  }

  void _stopAttackSimulation() {
    _attackTimer?.cancel();
    setState(() => _isAttackSimRunning = false);
  }

  // ==================== Load Testing ====================
  void _startLoadTest() {
    setState(() {
      _isLoadTestRunning = true;
      _loadHistory = List.filled(20, 0);
    });
    
    _loadTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final random = Random();
      final cpu = random.nextDouble() * 100;
      final memory = random.nextDouble() * 100;
      final network = random.nextDouble() * 100;
      
      setState(() {
        _cpuLoad = cpu;
        _memoryLoad = memory;
        _networkLoad = network;
        _loadHistory.add((cpu + memory + network) / 3);
        if (_loadHistory.length > 20) _loadHistory.removeAt(0);
      });
    });
  }

  void _stopLoadTest() {
    _loadTimer?.cancel();
    setState(() => _isLoadTestRunning = false);
  }

  // ==================== Vulnerability Scanner ====================
  void _startVulnerabilityScan() {
    setState(() {
      _isVulnScanRunning = true;
      _vulnerabilities.clear();
      _totalScanned = 0;
      _criticalFound = 0;
      _highFound = 0;
      _mediumFound = 0;
    });
    
    // Simulate scanning
    final timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final random = Random();
      final severity = random.nextInt(100);
      Vulnerability? vuln;
      
      if (severity < 5) {
        vuln = Vulnerability(
          id: _vulnerabilities.length + 1,
          name: 'Critical Buffer Overflow',
          severity: 'Critical',
          description: 'Remote code execution vulnerability',
          cvss: 9.8,
          timestamp: DateTime.now(),
        );
        _criticalFound++;
      } else if (severity < 15) {
        vuln = Vulnerability(
          id: _vulnerabilities.length + 1,
          name: 'SQL Injection',
          severity: 'High',
          description: 'Database injection vulnerability',
          cvss: 8.5,
          timestamp: DateTime.now(),
        );
        _highFound++;
      } else if (severity < 30) {
        vuln = Vulnerability(
          id: _vulnerabilities.length + 1,
          name: 'Cross-Site Scripting',
          severity: 'Medium',
          description: 'XSS vulnerability in web interface',
          cvss: 6.5,
          timestamp: DateTime.now(),
        );
        _mediumFound++;
      }
      
      if (vuln != null) {
        setState(() {
          _vulnerabilities.insert(0, vuln);
          if (_vulnerabilities.length > 30) _vulnerabilities.removeLast();
        });
      }
      
      setState(() => _totalScanned++);
      
      if (_totalScanned >= 100) {
        timer.cancel();
        setState(() => _isVulnScanRunning = false);
      }
    });
  }

  void _stopVulnerabilityScan() {
    setState(() => _isVulnScanRunning = false);
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.yellow;
      default: return Colors.blue;
    }
  }

  @override
  void dispose() {
    _networkTimer?.cancel();
    _attackTimer?.cancel();
    _loadTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Simulation Center'),
        backgroundColor: Colors.cyan.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.network_check), text: 'Network'),
            Tab(icon: Icon(Icons.flash_on), text: 'Attacks'),
            Tab(icon: Icon(Icons.speed), text: 'Load Test'),
            Tab(icon: Icon(Icons.security), text: 'Scanner'),
          ],
          onTap: (index) => setState(() => _selectedSimulation = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedSimulation,
        children: [
          _buildNetworkSimulation(),
          _buildAttackSimulation(),
          _buildLoadTesting(),
          _buildVulnerabilityScanner(),
        ],
      ),
    );
  }

  Widget _buildNetworkSimulation() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isNetworkSimRunning)
                ElevatedButton.icon(
                  onPressed: _startNetworkSimulation,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Simulation'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              if (_isNetworkSimRunning)
                ElevatedButton.icon(
                  onPressed: _stopNetworkSimulation,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text('Packets: $_packetCount', style: const TextStyle(color: Colors.white)),
                    Text('Data: ${(_totalBytes / 1024).toStringAsFixed(1)} KB', style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _networkPackets.length,
            itemBuilder: (ctx, i) {
              final packet = _networkPackets[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: packet.protocol == 'TCP' ? Colors.blue.withOpacity(0.2) :
                               packet.protocol == 'UDP' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(packet.protocol, style: TextStyle(color: packet.protocol == 'TCP' ? Colors.blue : packet.protocol == 'UDP' ? Colors.green : Colors.orange, fontSize: 10)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${packet.source} → ${packet.destination} (${packet.size} bytes)',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    Text(
                      '${packet.timestamp.hour}:${packet.timestamp.minute}:${packet.timestamp.second}',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
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

  Widget _buildAttackSimulation() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isAttackSimRunning)
                ElevatedButton.icon(
                  onPressed: _startAttackSimulation,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Attack Simulation'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              if (_isAttackSimRunning)
                ElevatedButton.icon(
                  onPressed: _stopAttackSimulation,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text('✅ Successful: $_successfulAttacks', style: const TextStyle(color: Colors.green)),
                    Text('❌ Failed: $_failedAttacks', style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _simulatedAttacks.length,
            itemBuilder: (ctx, i) {
              final attack = _simulatedAttacks[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: attack.success ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: attack.success ? Colors.green : Colors.red, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(attack.success ? Icons.check_circle : Icons.error, color: attack.success ? Colors.green : Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${attack.type} → ${attack.target}', style: const TextStyle(color: Colors.white)),
                          Text(attack.details, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                    Text(
                      '${attack.timestamp.hour}:${attack.timestamp.minute}:${attack.timestamp.second}',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
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

  Widget _buildLoadTesting() {
    final avgLoad = _loadHistory.isEmpty ? 0 : _loadHistory.reduce((a, b) => a + b) / _loadHistory.length;
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isLoadTestRunning)
                ElevatedButton.icon(
                  onPressed: _startLoadTest,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Load Test'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              if (_isLoadTestRunning)
                ElevatedButton.icon(
                  onPressed: _stopLoadTest,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
            ],
          ),
        ),
        if (_isLoadTestRunning) ...[
          _buildLoadMeter('CPU Load', _cpuLoad, Colors.cyan),
          _buildLoadMeter('Memory Load', _memoryLoad, Colors.green),
          _buildLoadMeter('Network Load', _networkLoad, Colors.orange),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Average System Load', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                Text('${avgLoad.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadMeter(String label, double value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white)),
              Text('${value.toStringAsFixed(1)}%', style: TextStyle(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey.shade800,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildVulnerabilityScanner() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isVulnScanRunning)
                ElevatedButton.icon(
                  onPressed: _startVulnerabilityScan,
                  icon: const Icon(Icons.search),
                  label: const Text('Start Scan'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
              if (_isVulnScanRunning)
                ElevatedButton.icon(
                  onPressed: _stopVulnerabilityScan,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              const SizedBox(width: 16),
              if (_isVulnScanRunning)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
            ],
          ),
        ),
        if (_totalScanned > 0) ...[
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScanStat('Scanned', '$_totalScanned', Colors.blue),
                _buildScanStat('Critical', '$_criticalFound', Colors.red),
                _buildScanStat('High', '$_highFound', Colors.orange),
                _buildScanStat('Medium', '$_mediumFound', Colors.yellow),
              ],
            ),
          ),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: _vulnerabilities.length,
            itemBuilder: (ctx, i) {
              final vuln = _vulnerabilities[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: _getSeverityColor(vuln.severity), width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(vuln.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(vuln.severity).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(vuln.severity, style: TextStyle(color: _getSeverityColor(vuln.severity), fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(vuln.description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('CVSS Score: ${vuln.cvss}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScanStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class NetworkPacket {
  final int id;
  final String source;
  final String destination;
  final int size;
  final String protocol;
  final DateTime timestamp;

  NetworkPacket({
    required this.id,
    required this.source,
    required this.destination,
    required this.size,
    required this.protocol,
    required this.timestamp,
  });
}

class SimulatedAttack {
  final int id;
  final String type;
  final String target;
  final bool success;
  final DateTime timestamp;
  final String details;

  SimulatedAttack({
    required this.id,
    required this.type,
    required this.target,
    required this.success,
    required this.timestamp,
    required this.details,
  });
}

class Vulnerability {
  final int id;
  final String name;
  final String severity;
  final String description;
  final double cvss;
  final DateTime timestamp;

  Vulnerability({
    required this.id,
    required this.name,
    required this.severity,
    required this.description,
    required this.cvss,
    required this.timestamp,
  });
}
