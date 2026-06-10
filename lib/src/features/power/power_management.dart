import 'package:flutter/material.dart';
import 'dart:async';

class PowerManagement extends StatefulWidget {
  const PowerManagement({super.key});

  @override
  State<PowerManagement> createState() => _PowerManagementState();
}

class _PowerManagementState extends State<PowerManagement> {
  int _batteryLevel = 85;
  bool _isCharging = true;
  bool _powerSaveMode = false;
  int _screenTimeout = 30;
  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isCharging && _batteryLevel > 0) {
        setState(() {
          _batteryLevel = (_batteryLevel - 1).clamp(0, 100);
        });
      }
    });
  }

  void _togglePowerSave() {
    setState(() {
      _powerSaveMode = !_powerSaveMode;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_powerSaveMode ? 'Power Save Mode ON' : 'Power Save Mode OFF')),
    );
  }

  void _setScreenTimeout(int minutes) {
    setState(() => _screenTimeout = minutes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Screen timeout set to $minutes minutes')),
    );
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  String _getBatteryStatus() {
    if (_isCharging) return 'Charging';
    if (_batteryLevel <= 15) return 'Critical';
    if (_batteryLevel <= 30) return 'Low';
    return 'Normal';
  }

  Color _getBatteryColor() {
    if (_batteryLevel <= 15) return Colors.red;
    if (_batteryLevel <= 30) return Colors.orange;
    if (_batteryLevel <= 60) return Colors.yellow;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Power Management'),
        backgroundColor: Colors.green.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Battery Card
            Container(
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
                          Text(
                            '$_batteryLevel%',
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _getBatteryStatus(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _batteryLevel / 100,
                    backgroundColor: Colors.grey.shade800,
                    color: _getBatteryColor(),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Power Modes Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('Power Modes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Power Save Mode', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Reduce background activity', style: TextStyle(color: Colors.grey)),
                    secondary: const Icon(Icons.battery_saver, color: Colors.green),
                    value: _powerSaveMode,
                    onChanged: (_) => _togglePowerSave(),
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Display Settings Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
