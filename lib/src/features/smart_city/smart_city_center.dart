import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SmartCityCenter extends StatefulWidget {
  const SmartCityCenter({super.key});

  @override
  State<SmartCityCenter> createState() => _SmartCityCenterState();
}

class _SmartCityCenterState extends State<SmartCityCenter> {
  int _selectedTab = 0;
  
  // Traffic Management
  List<TrafficLight> _trafficLights = [];
  List<Camera> _cameras = [];
  Map<String, int> _trafficFlow = {};
  int _accidentCount = 0;
  double _averageSpeed = 0;
  
  // Public Services
  List<PublicService> _services = [];
  List<EmergencyResponse> _emergencies = [];
  double _responseTime = 0;
  
  // Environmental Monitoring
  List<EnvironmentalSensor> _sensors = [];
  Map<String, double> _airQuality = {};
  Map<String, double> _noiseLevels = {};
  
  // Smart Infrastructure
  List<SmartInfrastructure> _infrastructure = [];
  List<MaintenanceRequest> _maintenance = [];
  double _infrastructureHealth = 0;

  @override
  void initState() {
    super.initState();
    _loadTrafficData();
    _loadPublicServices();
    _loadEnvironmentalData();
    _loadInfrastructure();
    _startMonitoring();
  }

  void _loadTrafficData() {
    _trafficLights = [
      TrafficLight('Intersection A', 'Green', 85, Icons.traffic, Colors.green, 45),
      TrafficLight('Intersection B', 'Red', 32, Icons.traffic, Colors.red, 28),
      TrafficLight('Intersection C', 'Yellow', 67, Icons.traffic, Colors.yellow, 52),
      TrafficLight('Intersection D', 'Green', 91, Icons.traffic, Colors.green, 38),
    ];
    
    _cameras = [
      Camera('Camera 1', 'Main St', 'Active', Icons.videocam, Colors.blue, 98),
      Camera('Camera 2', 'Oak Ave', 'Active', Icons.videocam, Colors.blue, 95),
      Camera('Camera 3', 'Pine Rd', 'Maintenance', Icons.videocam, Colors.orange, 45),
    ];
    
    _trafficFlow = {
      'Main St': 1250,
      'Oak Ave': 890,
      'Pine Rd': 560,
      'Broadway': 2100,
    };
    
    _accidentCount = 3;
    _averageSpeed = 42.5;
  }

  void _loadPublicServices() {
    _services = [
      PublicService('Police', 95, 'Available', Icons.local_police, Colors.blue, 12),
      PublicService('Fire', 88, 'Available', Icons.local_fire_department, Colors.red, 8),
      PublicService('Ambulance', 92, 'Busy', Icons.local_hospital, Colors.green, 15),
      PublicService('Waste Management', 78, 'Available', Icons.delete, Colors.orange, 45),
    ];
    
    _emergencies = [
      EmergencyResponse('E-001', 'Traffic Accident', 'Main St', 'In Progress', DateTime.now().subtract(const Duration(minutes: 15)), 85),
      EmergencyResponse('E-002', 'Fire Alert', 'Oak Ave', 'Dispatched', DateTime.now().subtract(const Duration(minutes: 30)), 92),
    ];
    
    _responseTime = 8.5;
  }

  void _loadEnvironmentalData() {
    _sensors = [
      EnvironmentalSensor('AQ-001', 'Main St', 85, Icons.air, Colors.green, 42),
      EnvironmentalSensor('AQ-002', 'Industrial Zone', 145, Icons.air, Colors.red, 68),
      EnvironmentalSensor('AQ-003', 'Park Area', 42, Icons.air, Colors.green, 25),
    ];
    
    _airQuality = {
      'Main St': 85,
      'Industrial Zone': 145,
      'Park Area': 42,
      'Residential': 65,
    };
    
    _noiseLevels = {
      'Main St': 65,
      'Industrial Zone': 85,
      'Park Area': 45,
      'Residential': 52,
    };
  }

  void _loadInfrastructure() {
    _infrastructure = [
      SmartInfrastructure('Street Light Network', 92, 'Active', Icons.lightbulb, Colors.yellow, 95),
      SmartInfrastructure('Water System', 88, 'Active', Icons.water_damage, Colors.blue, 92),
      SmartInfrastructure('Power Grid', 96, 'Active', Icons.electric_bolt, Colors.orange, 98),
      SmartInfrastructure('Waste System', 78, 'Maintenance', Icons.delete, Colors.green, 85),
    ];
    
    _maintenance = [
      MaintenanceRequest('M-001', 'Street Light Outage', 'Main St', 'Pending', DateTime.now().subtract(const Duration(hours: 5))),
      MaintenanceRequest('M-002', 'Water Leak', 'Oak Ave', 'In Progress', DateTime.now().subtract(const Duration(hours: 12))),
    ];
    
    _infrastructureHealth = 88.5;
  }

  void _startMonitoring() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          for (var light in _trafficLights) {
            light.vehicles = (light.vehicles + (random.nextInt(20) - 10)).clamp(0, 200);
          }
          
          for (var key in _trafficFlow.keys) {
            _trafficFlow[key] = (_trafficFlow[key]! + (random.nextInt(100) - 50)).clamp(100, 3000);
          }
          
          for (var sensor in _sensors) {
            sensor.value = (sensor.value + (random.nextInt(10) - 5)).clamp(0, 300);
          }
        });
      }
    });
  }

  void _adjustTrafficLight(TrafficLight light) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Control ${light.name}'),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              items: ['Green', 'Yellow', 'Red'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: 'State'),
            ),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Duration (s)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan), child: const Text('Apply')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Smart City Center'),
        backgroundColor: Colors.blue.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.traffic), text: 'Traffic'),
            Tab(icon: Icon(Icons.medical_services), text: 'Services'),
            Tab(icon: Icon(Icons.air), text: 'Environment'),
            Tab(icon: Icon(Icons.settings_input_component), text: 'Infra'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildTrafficTab(),
          _buildServicesTab(),
          _buildEnvironmentTab(),
          _buildInfrastructureTab(),
        ],
      ),
    );
  }

  Widget _buildTrafficTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.cyan.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTrafficStat('Avg Speed', '${_averageSpeed.toStringAsFixed(1)} km/h', Colors.cyan),
                _buildTrafficStat('Accidents', '$_accidentCount', Colors.red),
                _buildTrafficStat('Flow', '${_trafficFlow.values.reduce((a, b) => a + b)}', Colors.green),
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
                const Text('Traffic Lights', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._trafficLights.map((light) => ListTile(
                  leading: Icon(light.icon, color: light.color),
                  title: Text(light.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Vehicles: ${light.vehicles}/min • State: ${light.state}', style: TextStyle(color: light.state == 'Green' ? Colors.green : light.state == 'Yellow' ? Colors.yellow : Colors.red)),
                  trailing: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => _adjustTrafficLight(light),
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
                const Text('Traffic Flow', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._trafficFlow.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value} veh/h', style: const TextStyle(color: Colors.cyan)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 3000,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.cyan,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrafficStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildServicesTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade900, Colors.orange.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Emergency Response', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _responseTime / 15,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.white,
                    ),
                  ),
                  Text('${_responseTime.toStringAsFixed(1)} min', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _emergencies.length,
            itemBuilder: (ctx, i) {
              final emergency = _emergencies[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.warning, color: emergency.status == 'In Progress' ? Colors.orange : Colors.blue),
                  title: Text(emergency.type, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${emergency.location} • ${_formatTime(emergency.time)}', style: const TextStyle(color: Colors.grey)),
                  trailing: Text(emergency.status, style: const TextStyle(color: Colors.cyan)),
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
              const Text('Public Services', style: TextStyle(color: Colors.white)),
              const Divider(),
              ..._services.map((service) => ListTile(
                leading: Icon(service.icon, color: service.color),
                title: Text(service.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text('Availability: ${service.availability}%', style: const TextStyle(color: Colors.grey)),
                trailing: Text(service.status, style: TextStyle(color: service.status == 'Available' ? Colors.green : Colors.orange)),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnvironmentTab() {
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
                const Text('Air Quality Index', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._airQuality.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('AQI: ${entry.value}', style: TextStyle(color: entry.value > 100 ? Colors.red : entry.value > 50 ? Colors.orange : Colors.green)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 200,
                    backgroundColor: Colors.grey.shade800,
                    color: entry.value > 100 ? Colors.red : entry.value > 50 ? Colors.orange : Colors.green,
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
                const Text('Noise Levels (dB)', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._noiseLevels.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value} dB', style: TextStyle(color: entry.value > 70 ? Colors.red : Colors.orange)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 120,
                    backgroundColor: Colors.grey.shade800,
                    color: entry.value > 70 ? Colors.red : Colors.orange,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._sensors.map((sensor) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(sensor.icon, color: sensor.color),
              title: Text(sensor.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(sensor.location, style: const TextStyle(color: Colors.grey)),
              trailing: Text('${sensor.value} AQI', style: TextStyle(color: sensor.value > 100 ? Colors.red : Colors.green)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInfrastructureTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade900, Colors.purple.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Infrastructure Health', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _infrastructureHealth / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.white,
                    ),
                  ),
                  Text('${_infrastructureHealth.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _infrastructure.length,
            itemBuilder: (ctx, i) {
              final infra = _infrastructure[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(infra.icon, color: infra.color),
                  title: Text(infra.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Status: ${infra.status} • Efficiency: ${infra.efficiency}%', style: const TextStyle(color: Colors.grey)),
                  trailing: Text('${infra.health}%', style: const TextStyle(color: Colors.cyan)),
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
              const Text('Maintenance Requests', style: TextStyle(color: Colors.white)),
              const Divider(),
              ..._maintenance.map((req) => ListTile(
                dense: true,
                leading: Icon(Icons.build, color: Colors.orange),
                title: Text(req.issue, style: const TextStyle(color: Colors.white)),
                subtitle: Text('${req.location} • ${_formatTime(req.time)}', style: const TextStyle(color: Colors.grey)),
                trailing: Text(req.status, style: const TextStyle(color: req.status == 'In Progress' ? Colors.cyan : Colors.red)),
              )),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    return '${diff.inHours} hours ago';
  }
}

class TrafficLight {
  final String name;
  String state;
  final int vehicles;
  final IconData icon;
  final Color color;
  final int cycleTime;

  TrafficLight(this.name, this.state, this.vehicles, this.icon, this.color, this.cycleTime);
}

class Camera {
  final String name;
  final String location;
  final String status;
  final IconData icon;
  final Color color;
  final int quality;

  Camera(this.name, this.location, this.status, this.icon, this.color, this.quality);
}

class PublicService {
  final String name;
  final int availability;
  final String status;
  final IconData icon;
  final Color color;
  final int responseTime;

  PublicService(this.name, this.availability, this.status, this.icon, this.color, this.responseTime);
}

class EmergencyResponse {
  final String id;
  final String type;
  final String location;
  final String status;
  final DateTime time;
  final int priority;

  EmergencyResponse(this.id, this.type, this.location, this.status, this.time, this.priority);
}

class EnvironmentalSensor {
  final String name;
  final String location;
  int value;
  final IconData icon;
  final Color color;
  final int threshold;

  EnvironmentalSensor(this.name, this.location, this.value, this.icon, this.color, this.threshold);
}

class SmartInfrastructure {
  final String name;
  final double health;
  final String status;
  final IconData icon;
  final Color color;
  final int efficiency;

  SmartInfrastructure(this.name, this.health, this.status, this.icon, this.color, this.efficiency);
}

class MaintenanceRequest {
  final String id;
  final String issue;
  final String location;
  final String status;
  final DateTime time;

  MaintenanceRequest(this.id, this.issue, this.location, this.status, this.time);
}
