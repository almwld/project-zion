import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class EnergyCenter extends StatefulWidget {
  const EnergyCenter({super.key});

  @override
  State<EnergyCenter> createState() => _EnergyCenterState();
}

class _EnergyCenterState extends State<EnergyCenter> {
  int _selectedTab = 0;
  
  // Solar Energy
  double _solarOutput = 0;
  double _solarEfficiency = 0;
  List<SolarPanel> _solarPanels = [];
  Map<String, double> _solarHistory = {};
  
  // Wind Energy
  double _windSpeed = 0;
  double _windOutput = 0;
  List<WindTurbine> _turbines = [];
  
  // Battery Storage
  List<Battery> _batteries = [];
  double _totalCapacity = 0;
  double _currentCharge = 0;
  double _chargeRate = 0;
  
  // Energy Consumption
  List<EnergyConsumer> _consumers = [];
  double _totalConsumption = 0;
  Map<String, double> _consumptionBreakdown = {};
  
  // Sustainability Metrics
  double _carbonSaved = 0;
  double _energyIndependence = 0;
  List<SustainabilityGoal> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadSolarData();
    _loadWindData();
    _loadBatteries();
    _loadConsumers();
    _loadSustainabilityGoals();
    _startEnergySimulation();
  }

  void _loadSolarData() {
    _solarPanels = [
      SolarPanel('Roof Array', 5.2, 85, Icons.solar_power, Colors.orange, 92),
      SolarPanel('Ground Array', 3.8, 78, Icons.solar_power, Colors.yellow, 88),
      SolarPanel('Carport', 2.5, 92, Icons.solar_power, Colors.amber, 95),
    ];
    
    _solarHistory = {
      'Mon': 4.2,
      'Tue': 4.8,
      'Wed': 5.1,
      'Thu': 4.5,
      'Fri': 4.9,
      'Sat': 3.8,
      'Sun': 4.2,
    };
    
    _solarOutput = 12.5;
    _solarEfficiency = 87.5;
  }

  void _loadWindData() {
    _turbines = [
      WindTurbine('Turbine 1', 2.5, 82, Icons.wind_power, Colors.cyan, 45),
      WindTurbine('Turbine 2', 2.5, 79, Icons.wind_power, Colors.cyan, 42),
      WindTurbine('Turbine 3', 2.5, 88, Icons.wind_power, Colors.cyan, 48),
    ];
    
    _windSpeed = 12.5;
    _windOutput = 7.2;
  }

  void _loadBatteries() {
    _batteries = [
      Battery('Lithium Bank 1', 50, 85, Icons.battery_charging_full, Colors.green, 92),
      Battery('Lithium Bank 2', 50, 72, Icons.battery_charging_full, Colors.green, 88),
      Battery('Backup', 30, 45, Icons.battery_charging_full, Colors.orange, 75),
    ];
    
    _totalCapacity = _batteries.map((b) => b.capacity).reduce((a, b) => a + b);
    _currentCharge = _batteries.map((b) => b.capacity * b.charge / 100).reduce((a, b) => a + b);
    _chargeRate = 5.2;
  }

  void _loadConsumers() {
    _consumers = [
      EnergyConsumer('Main Building', 15.2, 'Active', Icons.business, Colors.blue, 45),
      EnergyConsumer('Data Center', 22.5, 'Active', Icons.storage, Colors.purple, 68),
      EnergyConsumer('Lighting', 8.5, 'Active', Icons.lightbulb, Colors.yellow, 32),
      EnergyConsumer('HVAC', 12.8, 'Active', Icons.ac_unit, Colors.cyan, 55),
    ];
    
    _totalConsumption = _consumers.map((c) => c.consumption).reduce((a, b) => a + b);
    _consumptionBreakdown = {
      'Data Center': 35,
      'Main Building': 25,
      'HVAC': 20,
      'Lighting': 15,
      'Other': 5,
    };
  }

  void _loadSustainabilityGoals() {
    _goals = [
      SustainabilityGoal('Carbon Neutral', 85, 100, DateTime.now().add(const Duration(days: 365)), Icons.eco, Colors.green),
      SustainabilityGoal('100% Renewable', 72, 100, DateTime.now().add(const Duration(days: 730)), Icons.solar_power, Colors.orange),
      SustainabilityGoal('Energy Efficiency', 68, 100, DateTime.now().add(const Duration(days: 180)), Icons.speed, Colors.blue),
    ];
    
    _carbonSaved = 125.5;
    _energyIndependence = 78.5;
  }

  void _startEnergySimulation() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _solarOutput = 8 + random.nextDouble() * 12;
          _windOutput = 4 + random.nextDouble() * 6;
          _windSpeed = 8 + random.nextDouble() * 10;
          
          for (var battery in _batteries) {
            battery.charge = (battery.charge + 0.5).clamp(0.0, 100.0);
          }
          _currentCharge = _batteries.map((b) => b.capacity * b.charge / 100).reduce((a, b) => a + b);
          
          for (var consumer in _consumers) {
            consumer.consumption = (consumer.consumption + (random.nextDouble() - 0.5) * 2).clamp(0.0, 50.0);
          }
          _totalConsumption = _consumers.map((c) => c.consumption).reduce((a, b) => a + b);
          
          _carbonSaved += 0.5;
          _energyIndependence = (_currentCharge / _totalConsumption * 100).clamp(0.0, 100.0);
        });
      }
    });
  }

  void _optimizeEnergy() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Energy Optimization'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Optimizing energy distribution...', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            LinearProgressIndicator(),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Energy optimization completed! Efficiency increased by 8%')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Energy Center'),
        backgroundColor: Colors.green.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.solar_power), text: 'Solar'),
            Tab(icon: Icon(Icons.wind_power), text: 'Wind'),
            Tab(icon: Icon(Icons.battery_charging_full), text: 'Storage'),
            Tab(icon: Icon(Icons.eco), text: 'Sustainability'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildSolarTab(),
          _buildWindTab(),
          _buildStorageTab(),
          _buildSustainabilityTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _optimizeEnergy,
        backgroundColor: Colors.green,
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }

  Widget _buildSolarTab() {
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
                colors: [Colors.orange.shade900, Colors.yellow.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Solar Output', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _solarOutput / 20,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.yellow,
                      ),
                    ),
                    Text('${_solarOutput.toStringAsFixed(1)} kW', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Efficiency: ${_solarEfficiency.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._solarPanels.map((panel) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(panel.icon, color: panel.color),
              title: Text(panel.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${panel.capacity} kW • Efficiency: ${panel.efficiency}%', style: const TextStyle(color: Colors.grey)),
              trailing: Text('${panel.output} kWh', style: const TextStyle(color: Colors.yellow)),
            ),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Weekly Production', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._solarHistory.entries.map((entry) => ListTile(
                  dense: true,
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value} kWh', style: const TextStyle(color: Colors.yellow)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 6,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.yellow,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindTab() {
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
                colors: [Colors.cyan.shade900, Colors.blue.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Wind Speed', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _windSpeed / 30,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.cyan,
                      ),
                    ),
                    Text('${_windSpeed.toStringAsFixed(1)} km/h', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Output: ${_windOutput.toStringAsFixed(1)} kW', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._turbines.map((turbine) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(turbine.icon, color: turbine.color),
              title: Text(turbine.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${turbine.capacity} kW • RPM: ${turbine.rpm}', style: const TextStyle(color: Colors.grey)),
              trailing: Text('${turbine.output} kW', style: const TextStyle(color: Colors.cyan)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStorageTab() {
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
                colors: [Colors.green.shade900, Colors.teal.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Battery Status', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _currentCharge / _totalCapacity,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.green,
                      ),
                    ),
                    Column(
                      children: [
                        Text('${(_currentCharge / _totalCapacity * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text('Charge', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${_currentCharge.toStringAsFixed(1)} / ${_totalCapacity.toStringAsFixed(1)} kWh', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text('Charge Rate: +${_chargeRate.toStringAsFixed(1)} kW', style: const TextStyle(color: Colors.green)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._batteries.map((battery) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(battery.icon, color: battery.color),
              title: Text(battery.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${battery.capacity} kWh • Health: ${battery.health}%', style: const TextStyle(color: Colors.grey)),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${battery.charge.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white)),
                  LinearProgressIndicator(
                    value: battery.charge / 100,
                    width: 60,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSustainabilityTab() {
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
                colors: [Colors.green.shade900, Colors.emerald.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetric('Carbon Saved', '${_carbonSaved.toStringAsFixed(1)} tons', Colors.green),
                _buildMetric('Independence', '${_energyIndependence.toStringAsFixed(1)}%', Colors.cyan),
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
                const Text('Energy Breakdown', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._consumptionBreakdown.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value}%', style: const TextStyle(color: Colors.cyan)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 100,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.cyan,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._goals.map((goal) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(goal.icon, color: goal.color),
              title: Text(goal.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text('Target: ${goal.target}% • Due: ${_formatDate(goal.deadline)}', style: const TextStyle(color: Colors.grey)),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${goal.progress.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white)),
                  LinearProgressIndicator(
                    value: goal.progress / 100,
                    width: 60,
                    backgroundColor: Colors.grey.shade800,
                    color: goal.color,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class SolarPanel {
  final String name;
  final double capacity;
  final double output;
  final IconData icon;
  final Color color;
  final double efficiency;

  SolarPanel(this.name, this.capacity, this.output, this.icon, this.color, this.efficiency);
}

class WindTurbine {
  final String name;
  final double capacity;
  final double output;
  final IconData icon;
  final Color color;
  final double rpm;

  WindTurbine(this.name, this.capacity, this.output, this.icon, this.color, this.rpm);
}

class Battery {
  final String name;
  final double capacity;
  double charge;
  final IconData icon;
  final Color color;
  final double health;

  Battery(this.name, this.capacity, this.charge, this.icon, this.color, this.health);
}

class EnergyConsumer {
  final String name;
  double consumption;
  final String status;
  final IconData icon;
  final Color color;
  final double efficiency;

  EnergyConsumer(this.name, this.consumption, this.status, this.icon, this.color, this.efficiency);
}

class SustainabilityGoal {
  final String name;
  double progress;
  final double target;
  final DateTime deadline;
  final IconData icon;
  final Color color;

  SustainabilityGoal(this.name, this.progress, this.target, this.deadline, this.icon, this.color);
}
