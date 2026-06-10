import 'package:flutter/material.dart';
import 'package:power_settings/power_settings.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';

class PowerManagement extends StatefulWidget {
  const PowerManagement({super.key});

  @override
  State<PowerManagement> createState() => _PowerManagementState();
}

class _PowerManagementState extends State<PowerManagement> {
  final Battery _battery = Battery();
  late StreamSubscription<BatteryState> _batteryStateSubscription;
  
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  bool _isCharging = false;
  bool _powerSaveMode = false;
  bool _performanceMode = false;
  int _screenTimeout = 30;
  double _brightness = 0.5;
  List<AppPowerUsage> _appPowerUsage = [];

  @override
  void initState() {
    super.initState();
    _initBattery();
    _loadSettings();
    _loadAppPowerUsage();
  }

  Future<void> _initBattery() async {
    _batteryLevel = await _battery.batteryLevel;
    _batteryState = await _battery.batteryState;
    _isCharging = _batteryState == BatteryState.charging || _batteryState == BatteryState.full;
    
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
        _isCharging = state == BatteryState.charging || state == BatteryState.full;
      });
    });
    
    _battery.onBatteryLevelChanged.listen((int level) {
      setState(() => _batteryLevel = level);
    });
  }

  Future<void> _loadSettings() async {
    // تحميل الإعدادات المحفوظة
    setState(() {
      _powerSaveMode = false;
      _performanceMode = false;
      _screenTimeout = 30;
      _brightness = 0.7;
    });
  }

  Future<void> _loadAppPowerUsage() async {
    // محاكاة استهلاك التطبيقات للطاقة
    _appPowerUsage = [
      AppPowerUsage(name: 'SI Agent', usage: 15, icon: Icons.psychology, color: Colors.purple),
      AppPowerUsage(name: 'Cosmic Terminal', usage: 8, icon: Icons.terminal, color: Colors.green),
      AppPowerUsage(name: 'Network Scanner', usage: 22, icon: Icons.network_check, color: Colors.cyan),
      AppPowerUsage(name: 'Web Browser', usage: 18, icon: Icons.public, color: Colors.blue),
      AppPowerUsage(name: 'System', usage: 12, icon: Icons.android, color: Colors.grey),
    ];
  }

  Future<void> _togglePowerSave() async {
    setState(() {
      _powerSaveMode = !_powerSaveMode;
      if (_powerSaveMode) _performanceMode = false;
    });
    if (_powerSaveMode) {
      await PowerSettings.setPowerSaveMode(true);
    } else {
      await PowerSettings.setPowerSaveMode(false);
    }
  }

  Future<void> _togglePerformanceMode() async {
    setState(() {
      _performanceMode = !_performanceMode;
      if (_performanceMode) _powerSaveMode = false;
    });
  }

  Future<void> _setScreenTimeout(int minutes) async {
    setState(() => _screenTimeout = minutes);
    await PowerSettings.setScreenTimeout(minutes);
  }

  Future<void> _setBrightness(double value) async {
    setState(() => _brightness = value);
    // ضبط السطوع
  }

  String _getBatteryStatus() {
    if (_isCharging) return 'Charging';
    switch (_batteryState) {
      case BatteryState.charging: return 'Charging';
      case BatteryState.discharging: return 'Discharging';
      case BatteryState.full: return 'Full';
      default: return 'Unknown';
    }
  }

  Color _getBatteryColor() {
    if (_batteryLevel <= 15) return Colors.red;
    if (_batteryLevel <= 30) return Colors.orange;
    if (_batteryLevel <= 60) return Colors.yellow;
    return Colors.green;
  }

  String _estimateRemainingTime() {
    if (_isCharging) {
      return '${((100 - _batteryLevel) / 1.5).toInt()} min to full';
    } else {
      final estimate = (_batteryLevel / 8).toInt();
      return '$estimate hours remaining';
    }
  }

  @override
  void dispose() {
    _batteryStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Power Management'),
        backgroundColor: Colors.green.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildBatteryCard()),
          SliverToBoxAdapter(child: _buildPowerModesCard()),
          SliverToBoxAdapter(child: _buildDisplayCard()),
          SliverToBoxAdapter(child: _buildAppPowerCard()),
        ],
      ),
    );
  }

  Widget _buildBatteryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.battery_full, color: _getBatteryColor(), size: 48),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$_batteryLevel%', style: TextStyle(color: _getBatteryColor(), fontSize: 36, fontWeight: FontWeight.bold)),
                  Text(_getBatteryStatus(), style: const TextStyle(color: Colors.white70)),
                  Text(_estimateRemainingTime(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _batteryLevel / 100,
            backgroundColor: Colors.grey.shade800,
            color: _getBatteryColor(),
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildPowerModesCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Power Modes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Power Save Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Reduce background activity to save battery', style: TextStyle(color: Colors.grey)),
            secondary: const Icon(Icons.battery_saver, color: Colors.green),
            value: _powerSaveMode,
            onChanged: (_) => _togglePowerSave(),
            activeColor: Colors.green,
          ),
          SwitchListTile(
            title: const Text('Performance Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Maximum performance for heavy tasks', style: TextStyle(color: Colors.grey)),
            secondary: const Icon(Icons.speed, color: Colors.orange),
            value: _performanceMode,
            onChanged: (_) => _togglePerformanceMode(),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Display Settings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Screen Timeout', style: TextStyle(color: Colors.white)),
            subtitle: Slider(
              value: _screenTimeout.toDouble(),
              min: 15,
              max: 300,
              divisions: 19,
              activeColor: Colors.blue,
              onChanged: (v) => _setScreenTimeout(v.toInt()),
            ),
            trailing: Text('${_screenTimeout}s', style: const TextStyle(color: Colors.blue)),
          ),
          ListTile(
            title: const Text('Brightness', style: TextStyle(color: Colors.white)),
            subtitle: Slider(
              value: _brightness,
              min: 0.0,
              max: 1.0,
              activeColor: Colors.yellow,
              onChanged: (v) => _setBrightness(v),
            ),
            trailing: Text('${(_brightness * 100).toInt()}%', style: const TextStyle(color: Colors.yellow)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppPowerCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Battery Usage by App', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._appPowerUsage.map((app) => ListTile(
            leading: Icon(app.icon, color: app.color),
            title: Text(app.name, style: const TextStyle(color: Colors.white)),
            trailing: Text('${app.usage}%', style: TextStyle(color: app.color, fontWeight: FontWeight.bold)),
            subtitle: LinearProgressIndicator(
              value: app.usage / 100,
              backgroundColor: Colors.grey.shade800,
              color: app.color,
            ),
          )),
        ],
      ),
    );
  }
}

class AppPowerUsage {
  final String name;
  final int usage;
  final IconData icon;
  final Color color;

  AppPowerUsage({
    required this.name,
    required this.usage,
    required this.icon,
    required this.color,
  });
}
