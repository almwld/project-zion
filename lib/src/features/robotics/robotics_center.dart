import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class RoboticsCenter extends StatefulWidget {
  const RoboticsCenter({super.key});

  @override
  State<RoboticsCenter> createState() => _RoboticsCenterState();
}

class _RoboticsCenterState extends State<RoboticsCenter> {
  int _selectedTab = 0;
  
  // Robot Fleet
  List<Robot> _robots = [];
  List<Robot> _activeRobots = [];
  List<RobotTask> _tasks = [];
  
  // Sensors & Status
  Map<String, SensorData> _sensorData = {};
  Map<String, double> _batteryLevels = {};
  Map<String, String> _robotStatus = {};
  
  // Automation Rules
  List<AutomationRule> _automationRules = [];
  List<TriggerEvent> _triggerEvents = [];
  
  // Mission Logs
  List<MissionLog> _missionLogs = [];
  double _missionSuccessRate = 0;
  int _totalMissions = 0;

  @override
  void initState() {
    super.initState();
    _loadRobots();
    _loadAutomationRules();
    _loadMissionLogs();
    _startMonitoring();
  }

  void _loadRobots() {
    _robots = [
      Robot('R2-D2', 'Explorer', 'Online', 92, Icons.android, Colors.blue, 85, 45.2),
      Robot('Wall-E', 'Cleaner', 'Online', 78, Icons.cleaning_services, Colors.green, 65, 32.5),
      Robot('Optimus', 'Security', 'Offline', 45, Icons.security, Colors.red, 30, 12.8),
      Robot('Spot', 'Inspector', 'Online', 96, Icons.pets, Colors.orange, 92, 67.3),
      Robot('Atlas', 'Carrier', 'Maintenance', 65, Icons.handyman, Colors.purple, 55, 23.1),
    ];
    
    _activeRobots = _robots.where((r) => r.status == 'Online').toList();
    
    for (var robot in _robots) {
      _batteryLevels[robot.name] = robot.battery;
      _robotStatus[robot.name] = robot.status;
    }
    
    _tasks = [
      RobotTask('T-001', 'Inspect Area A', 'R2-D2', 'In Progress', 75, DateTime.now().add(const Duration(minutes: 30))),
      RobotTask('T-002', 'Clean Sector 3', 'Wall-E', 'Pending', 0, DateTime.now().add(const Duration(hours: 2))),
      RobotTask('T-003', 'Security Patrol', 'Optimus', 'Blocked', 0, DateTime.now().add(const Duration(hours: 1))),
    ];
    
    _sensorData = {
      'R2-D2': SensorData(22.5, 45, 2.3, 890),
      'Wall-E': SensorData(24.1, 38, 1.8, 450),
      'Spot': SensorData(21.3, 52, 3.1, 1200),
    };
  }

  void _loadAutomationRules() {
    _automationRules = [
      AutomationRule('Low Battery Alert', 'Battery < 20%', 'Send Notification', true, Icons.battery_alert, Colors.red),
      AutomationRule('Auto-Charge', 'Battery < 30%', 'Return to Dock', true, Icons.ev_station, Colors.green),
      AutomationRule('Emergency Stop', 'Obstacle Detected', 'Stop All Motion', true, Icons.stop, Colors.orange),
    ];
    
    _triggerEvents = [
      TriggerEvent('Battery Low', DateTime.now().subtract(const Duration(minutes: 15)), 'R2-D2', 'Triggered'),
      TriggerEvent('Obstacle Detected', DateTime.now().subtract(const Duration(hours: 2)), 'Wall-E', 'Resolved'),
    ];
  }

  void _loadMissionLogs() {
    _missionLogs = [
      MissionLog('M-001', 'Area Inspection', 'R2-D2', 'Completed', DateTime.now().subtract(const Duration(hours: 3)), 98),
      MissionLog('M-002', 'Security Check', 'Spot', 'Completed', DateTime.now().subtract(const Duration(hours: 6)), 95),
      MissionLog('M-003', 'Cargo Transport', 'Atlas', 'Failed', DateTime.now().subtract(const Duration(days: 1)), 45),
    ];
    
    _totalMissions = _missionLogs.length;
    _missionSuccessRate = (_missionLogs.where((m) => m.status == 'Completed').length / _totalMissions) * 100;
  }

  void _startMonitoring() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          for (var robot in _activeRobots) {
            robot.battery = (robot.battery - 0.5).clamp(0.0, 100.0);
            _batteryLevels[robot.name] = robot.battery;
            
            if (robot.battery < 20) {
              _triggerEvents.insert(0, TriggerEvent('Low Battery Alert', DateTime.now(), robot.name, 'Active'));
              if (_triggerEvents.length > 10) _triggerEvents.removeLast();
            }
          }
        });
      }
    });
  }

  void _controlRobot(String robotName, String command) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Command "$command" sent to $robotName')),
    );
  }

  void _createAutomationRule() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Automation Rule'),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Trigger'), style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Action'), style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: ['Robot', 'Notification', 'Stop', 'Charge'].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: 'Action Type'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan), child: const Text('Create')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Robotics Center'),
        backgroundColor: Colors.cyan.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.android), text: 'Fleet'),
            Tab(icon: Icon(Icons.settings), text: 'Automation'),
            Tab(icon: Icon(Icons.history), text: 'Missions'),
            Tab(icon: Icon(Icons.sensors), text: 'Sensors'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildFleetTab(),
          _buildAutomationTab(),
          _buildMissionsTab(),
          _buildSensorsTab(),
        ],
      ),
    );
  }

  Widget _buildFleetTab() {
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
              _buildFleetStat('Total Robots', '${_robots.length}', Colors.blue),
              _buildFleetStat('Active', '${_activeRobots.length}', Colors.green),
              _buildFleetStat('Success Rate', '${_missionSuccessRate.toStringAsFixed(1)}%', Colors.cyan),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _robots.length,
            itemBuilder: (ctx, i) {
              final robot = _robots[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ExpansionTile(
                  leading: Icon(robot.icon, color: robot.color),
                  title: Text(robot.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('${robot.type} • ${robot.status}', style: TextStyle(color: robot.status == 'Online' ? Colors.green : Colors.red)),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${robot.battery.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white)),
                      LinearProgressIndicator(
                        value: robot.battery / 100,
                        width: 60,
                        backgroundColor: Colors.grey.shade800,
                        color: robot.battery > 50 ? Colors.green : robot.battery > 20 ? Colors.orange : Colors.red,
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildControlButton('Move', Icons.directions, () => _controlRobot(robot.name, 'Move')),
                              _buildControlButton('Stop', Icons.stop, () => _controlRobot(robot.name, 'Stop')),
                              _buildControlButton('Charge', Icons.battery_charging_full, () => _controlRobot(robot.name, 'Charge')),
                              _buildControlButton('Scan', Icons.qr_code_scanner, () => _controlRobot(robot.name, 'Scan')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Position: X: ${45.2 + i * 10} | Y: ${23.5 + i * 5} | Z: 0', style: const TextStyle(color: Colors.grey)),
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

  Widget _buildFleetStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildControlButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
    );
  }

  Widget _buildAutomationTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _createAutomationRule,
            icon: const Icon(Icons.add),
            label: const Text('CREATE AUTOMATION RULE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _automationRules.length,
            itemBuilder: (ctx, i) {
              final rule = _automationRules[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(rule.icon, color: rule.color),
                  title: Text(rule.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('IF ${rule.trigger} THEN ${rule.action}', style: const TextStyle(color: Colors.grey)),
                  trailing: Switch(value: rule.enabled, onChanged: (_) {}),
                ),
              );
            },
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
              const Text('Recent Events', style: TextStyle(color: Colors.white, fontSize: 16)),
              const Divider(),
              ..._triggerEvents.take(5).map((event) => ListTile(
                dense: true,
                leading: Icon(Icons.notifications, color: Colors.orange),
                title: Text(event.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text('${event.robot} • ${_formatTime(event.time)}', style: const TextStyle(color: Colors.grey)),
                trailing: Text(event.status, style: TextStyle(color: event.status == 'Triggered' ? Colors.red : Colors.green)),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMissionsTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.cyan.shade900, Colors.blue.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMissionStat('Total', '$_totalMissions', Colors.white),
              _buildMissionStat('Success', '${_missionLogs.where((m) => m.status == 'Completed').length}', Colors.green),
              _buildMissionStat('Rate', '${_missionSuccessRate.toStringAsFixed(1)}%', Colors.cyan),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _missionLogs.length,
            itemBuilder: (ctx, i) {
              final mission = _missionLogs[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(
                    mission.status == 'Completed' ? Icons.check_circle : Icons.error,
                    color: mission.status == 'Completed' ? Colors.green : Colors.red,
                  ),
                  title: Text(mission.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Robot: ${mission.robot} • ${_formatDate(mission.date)}', style: const TextStyle(color: Colors.grey)),
                  trailing: Text('Score: ${mission.score}%', style: const TextStyle(color: Colors.cyan)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMissionStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildSensorsTab() {
    return ListView.builder(
      itemCount: _sensorData.length,
      itemBuilder: (ctx, i) {
        final entry = _sensorData.entries.elementAt(i);
        final robot = entry.key;
        final data = entry.value;
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            leading: const Icon(Icons.sensors, color: Colors.cyan),
            title: Text(robot, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSensorRow('Temperature', '${data.temperature}°C', 25, 30, Colors.red),
                    _buildSensorRow('Humidity', '${data.humidity}%', 40, 60, Colors.blue),
                    _buildSensorRow('Distance', '${data.distance}m', 0, 5, Colors.green),
                    _buildSensorRow('Light', '${data.light} lux', 0, 1000, Colors.yellow),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSensorRow(String label, String value, double min, double max, Color color) {
    final numericValue = double.tryParse(value.split('°')[0]) ?? 0;
    final progress = ((numericValue - min) / (max - min)).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70)),
              Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade800,
            color: color,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    return '${diff.inHours} hours ago';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

class Robot {
  final String name;
  final String type;
  String status;
  double battery;
  final IconData icon;
  final Color color;
  final double speed;
  final double payload;

  Robot(this.name, this.type, this.status, this.battery, this.icon, this.color, this.speed, this.payload);
}

class RobotTask {
  final String id;
  final String description;
  final String robot;
  String status;
  final int progress;
  final DateTime deadline;

  RobotTask(this.id, this.description, this.robot, this.status, this.progress, this.deadline);
}

class SensorData {
  final double temperature;
  final double humidity;
  final double distance;
  final int light;

  SensorData(this.temperature, this.humidity, this.distance, this.light);
}

class AutomationRule {
  final String name;
  final String trigger;
  final String action;
  bool enabled;
  final IconData icon;
  final Color color;

  AutomationRule(this.name, this.trigger, this.action, this.enabled, this.icon, this.color);
}

class TriggerEvent {
  final String name;
  final DateTime time;
  final String robot;
  final String status;

  TriggerEvent(this.name, this.time, this.robot, this.status);
}

class MissionLog {
  final String id;
  final String name;
  final String robot;
  final String status;
  final DateTime date;
  final int score;

  MissionLog(this.id, this.name, this.robot, this.status, this.date, this.score);
}
