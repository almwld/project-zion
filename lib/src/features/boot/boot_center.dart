import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class BootCenter extends StatefulWidget {
  const BootCenter({super.key});

  @override
  State<BootCenter> createState() => _BootCenterState();
}

class _BootCenterState extends State<BootCenter> {
  bool _autoStart = true;
  bool _fastBoot = true;
  int _bootDelay = 0;
  String _defaultDesktop = 'glass';
  List<String> _startupApps = [];
  List<BootLog> _bootLogs = [];
  bool _isAnalyzing = false;
  double _bootTime = 0;

  final List<String> _desktopOptions = ['glass', 'classic', 'minimal', 'performance'];
  final List<String> _availableApps = [
    'Terminal', 'SI Agent', 'Network Monitor', 'Security Center', 
    'File Manager', 'Notification Center', 'Power Management'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadBootLogs();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoStart = prefs.getBool('auto_start') ?? true;
      _fastBoot = prefs.getBool('fast_boot') ?? true;
      _bootDelay = prefs.getInt('boot_delay') ?? 0;
      _defaultDesktop = prefs.getString('default_desktop') ?? 'glass';
      _startupApps = prefs.getStringList('startup_apps') ?? ['Terminal', 'SI Agent'];
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    else if (value is int) await prefs.setInt(key, value);
    else if (value is String) await prefs.setString(key, value);
    else if (value is List<String>) await prefs.setStringList(key, value);
    setState(() {});
  }

  void _loadBootLogs() {
    _bootLogs = [
      BootLog('System boot', DateTime.now().subtract(const Duration(hours: 2)), 'SUCCESS', 3.2),
      BootLog('Kernel loaded', DateTime.now().subtract(const Duration(hours: 2)), 'SUCCESS', 1.1),
      BootLog('Services started', DateTime.now().subtract(const Duration(hours: 2)), 'SUCCESS', 2.0),
      BootLog('Desktop loaded', DateTime.now().subtract(const Duration(hours: 2)), 'SUCCESS', 1.5),
    ];
    _bootTime = 7.8;
  }

  void _addToStartup(String app) {
    if (!_startupApps.contains(app)) {
      setState(() {
        _startupApps.add(app);
        _saveSetting('startup_apps', _startupApps);
      });
    }
  }

  void _removeFromStartup(String app) {
    setState(() {
      _startupApps.remove(app);
      _saveSetting('startup_apps', _startupApps);
    });
  }

  void _analyzeBootTime() async {
    setState(() {
      _isAnalyzing = true;
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isAnalyzing = false;
      _bootTime = 6.5;
      _bootLogs = [
        BootLog('System boot', DateTime.now(), 'SUCCESS', 2.8),
        BootLog('Kernel loaded', DateTime.now(), 'SUCCESS', 0.9),
        BootLog('Services started', DateTime.now(), 'SUCCESS', 1.8),
        BootLog('Desktop loaded', DateTime.now(), 'SUCCESS', 1.0),
      ];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Boot analysis completed!')),
    );
  }

  void _optimizeBoot() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Optimize Boot'),
        content: const Text('Disable unnecessary startup apps to improve boot time?'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                _startupApps = ['Terminal', 'SI Agent'];
                _saveSetting('startup_apps', _startupApps);
                _fastBoot = true;
                _saveSetting('fast_boot', true);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Boot optimized!')),
              );
            },
            child: const Text('Optimize'),
          ),
        ],
      ),
    );
  }

  String _getDesktopName(String value) {
    switch (value) {
      case 'glass': return 'Glass Desktop';
      case 'classic': return 'Classic Desktop';
      case 'minimal': return 'Minimal Desktop';
      case 'performance': return 'Performance Mode';
      default: return 'Glass Desktop';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Boot & Startup'),
        backgroundColor: Colors.deepOrange.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildBootStatsCard()),
          SliverToBoxAdapter(child: _buildBootSettings()),
          SliverToBoxAdapter(child: _buildStartupApps()),
          SliverToBoxAdapter(child: _buildBootLogs()),
        ],
      ),
    );
  }

  Widget _buildBootStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepOrange.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.speed, color: Colors.white),
              SizedBox(width: 8),
              Text('Boot Performance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBootStat('Boot Time', '${_bootTime.toStringAsFixed(1)}s', Colors.cyan),
              _buildBootStat('Startup Apps', '${_startupApps.length}', Colors.green),
              _buildBootStat('Status', _fastBoot ? 'Fast Boot' : 'Normal', Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeBootTime,
                  icon: const Icon(Icons.analytics),
                  label: const Text('ANALYZE'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _optimizeBoot,
                  icon: const Icon(Icons.speed),
                  label: const Text('OPTIMIZE'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
            ],
          ),
          if (_isAnalyzing) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildBootStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildBootSettings() {
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
          const Text('Boot Configuration', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('Auto Start'),
            subtitle: const Text('Launch Zion OS on device boot'),
            value: _autoStart,
            onChanged: (v) => _saveSetting('auto_start', v),
            secondary: const Icon(Icons.power_settings_new),
          ),
          SwitchListTile(
            title: const Text('Fast Boot'),
            subtitle: const Text('Skip unnecessary checks'),
            value: _fastBoot,
            onChanged: (v) => _saveSetting('fast_boot', v),
            secondary: const Icon(Icons.rocket_launch),
          ),
          ListTile(
            title: const Text('Boot Delay'),
            subtitle: Slider(
              value: _bootDelay.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => _saveSetting('boot_delay', v.toInt()),
            ),
            trailing: Text('${_bootDelay}s', style: const TextStyle(color: Colors.deepOrange)),
          ),
          ListTile(
            title: const Text('Default Desktop'),
            trailing: DropdownButton<String>(
              value: _defaultDesktop,
              items: _desktopOptions.map((opt) => DropdownMenuItem(value: opt, child: Text(_getDesktopName(opt)))).toList(),
              onChanged: (v) => _saveSetting('default_desktop', v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartupApps() {
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
              Icon(Icons.apps, color: Colors.green),
              SizedBox(width: 8),
              Text('Startup Applications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          ..._startupApps.map((app) => ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(app, style: const TextStyle(color: Colors.white)),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removeFromStartup(app),
            ),
          )),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            hint: const Text('Add application', style: TextStyle(color: Colors.grey)),
            items: _availableApps.where((a) => !_startupApps.contains(a)).map((app) => DropdownMenuItem(value: app, child: Text(app))).toList(),
            onChanged: (value) {
              if (value != null) _addToStartup(value);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBootLogs() {
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
              Icon(Icons.history, color: Colors.cyan),
              SizedBox(width: 8),
              Text('Boot Logs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          ..._bootLogs.map((log) => ListTile(
            leading: Icon(
              log.status == 'SUCCESS' ? Icons.check_circle : Icons.error,
              color: log.status == 'SUCCESS' ? Colors.green : Colors.red,
            ),
            title: Text(log.event, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${_formatTime(log.time)} • ${log.duration}s', style: const TextStyle(color: Colors.grey)),
            trailing: Text(log.status, style: TextStyle(color: log.status == 'SUCCESS' ? Colors.green : Colors.red)),
          )),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}

class BootLog {
  final String event;
  final DateTime time;
  final String status;
  final double duration;

  BootLog(this.event, this.time, this.status, this.duration);
}
