import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class GeospatialCenter extends StatefulWidget {
  const GeospatialCenter({super.key});

  @override
  State<GeospatialCenter> createState() => _GeospatialCenterState();
}

class _GeospatialCenterState extends State<GeospatialCenter> {
  int _selectedTab = 0;
  
  // Map Data
  List<MapMarker> _markers = [];
  List<HeatmapPoint> _heatmapData = [];
  List<RoutePath> _routes = [];
  
  // Location Analytics
  List<LocationVisit> _visits = [];
  Map<String, int> _locationFrequency = {};
  double _totalDistance = 0;
  double _averageSpeed = 0;
  
  // Geofencing
  List<Geofence> _geofences = [];
  List<GeofenceAlert> _alerts = [];
  
  // Satellite Data
  List<Satellite> _satellites = [];
  Map<String, WeatherData> _weatherData = {};
  List<Earthquake> _earthquakes = [];

  @override
  void initState() {
    super.initState();
    _loadMapData();
    _loadLocationAnalytics();
    _loadGeofences();
    _loadSatelliteData();
    _startLocationSimulation();
  }

  void _loadMapData() {
    _markers = [
      MapMarker('Headquarters', 24.7136, 46.6753, Icons.location_city, Colors.blue, 'Main Base'),
      MapMarker('Server Farm', 24.7200, 46.6800, Icons.storage, Colors.green, 'Data Center'),
      MapMarker('Control Center', 24.7080, 46.6700, Icons.computer, Colors.purple, 'Operations'),
      MapMarker('Backup Site', 24.7300, 46.6900, Icons.backup, Colors.orange, 'Disaster Recovery'),
    ];
    
    _heatmapData = [
      HeatmapPoint(24.7136, 46.6753, 95),
      HeatmapPoint(24.7150, 46.6760, 85),
      HeatmapPoint(24.7120, 46.6740, 75),
      HeatmapPoint(24.7200, 46.6800, 65),
      HeatmapPoint(24.7080, 46.6700, 55),
    ];
    
    _routes = [
      RoutePath('Route A', [
        LocationPoint(24.7136, 46.6753),
        LocationPoint(24.7150, 46.6770),
        LocationPoint(24.7200, 46.6800),
      ], 2.5, Colors.blue),
      RoutePath('Route B', [
        LocationPoint(24.7136, 46.6753),
        LocationPoint(24.7100, 46.6720),
        LocationPoint(24.7080, 46.6700),
      ], 1.8, Colors.green),
    ];
  }

  void _loadLocationAnalytics() {
    _visits = [
      LocationVisit('Headquarters', DateTime.now().subtract(const Duration(hours: 1)), DateTime.now(), 45),
      LocationVisit('Server Farm', DateTime.now().subtract(const Duration(hours: 3)), DateTime.now().subtract(const Duration(hours: 2)), 35),
      LocationVisit('Control Center', DateTime.now().subtract(const Duration(hours: 5)), DateTime.now().subtract(const Duration(hours: 4)), 28),
    ];
    
    _locationFrequency = {
      'Headquarters': 45,
      'Server Farm': 32,
      'Control Center': 28,
      'Backup Site': 12,
    };
    
    _totalDistance = 245.8;
    _averageSpeed = 45.5;
  }

  void _loadGeofences() {
    _geofences = [
      Geofence('HQ Zone', 24.7136, 46.6753, 500, 'Active', Icons.location_on, Colors.blue),
      Geofence('Data Center Zone', 24.7200, 46.6800, 300, 'Active', Icons.storage, Colors.green),
      Geofence('Restricted Area', 24.7080, 46.6700, 200, 'Inactive', Icons.warning, Colors.red),
    ];
    
    _alerts = [
      GeofenceAlert('Entry Alert', 'HQ Zone', DateTime.now().subtract(const Duration(minutes: 30)), 'Authorized', Icons.login),
      GeofenceAlert('Exit Alert', 'Data Center Zone', DateTime.now().subtract(const Duration(hours: 2)), 'Unauthorized', Icons.logout),
    ];
  }

  void _loadSatelliteData() {
    _satellites = [
      Satellite('Landsat-9', 705, 'Active', 98.5, Icons.satellite, Colors.blue),
      Satellite('Sentinel-2', 786, 'Active', 99.2, Icons.satellite, Colors.green),
      Satellite('GeoEye-1', 681, 'Maintenance', 95.8, Icons.satellite, Colors.orange),
    ];
    
    _weatherData = {
      'Riyadh': WeatherData(32.5, 18, 5.2, 'Clear'),
      'Jeddah': WeatherData(35.2, 45, 12.8, 'Hot'),
      'Dammam': WeatherData(30.8, 30, 8.5, 'Humid'),
    };
    
    _earthquakes = [
      Earthquake(4.2, 'Turkey', DateTime.now().subtract(const Duration(hours: 5)), 25.0, 'Moderate'),
      Earthquake(3.8, 'Iran', DateTime.now().subtract(const Duration(days: 1)), 15.0, 'Light'),
    ];
  }

  void _startLocationSimulation() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          for (var marker in _markers) {
            marker.lat += (random.nextDouble() - 0.5) * 0.001;
            marker.lng += (random.nextDouble() - 0.5) * 0.001;
          }
        });
      }
    });
  }

  void _addGeofence() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Geofence'),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Name'), style: const TextStyle(color: Colors.white)),
            TextField(decoration: const InputDecoration(labelText: 'Latitude'), style: const TextStyle(color: Colors.white), keyboardType: TextInputType.number),
            TextField(decoration: const InputDecoration(labelText: 'Longitude'), style: const TextStyle(color: Colors.white), keyboardType: TextInputType.number),
            TextField(decoration: const InputDecoration(labelText: 'Radius (m)'), style: const TextStyle(color: Colors.white), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Create')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Geospatial Center'),
        backgroundColor: Colors.green.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.map), text: 'Map'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.location_on), text: 'Geofencing'),
            Tab(icon: Icon(Icons.satellite), text: 'Satellite'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildMapTab(),
          _buildAnalyticsTab(),
          _buildGeofencingTab(),
          _buildSatelliteTab(),
        ],
      ),
      floatingActionButton: _selectedTab == 2 ? FloatingActionButton(
        onPressed: _addGeofence,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_location),
      ) : null,
    );
  }

  Widget _buildMapTab() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomPaint(
              painter: MapPainter(_markers, _routes),
              size: Size.infinite,
            ),
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
              const Text('Map Markers', style: TextStyle(color: Colors.white)),
              ..._markers.map((m) => ListTile(
                dense: true,
                leading: Icon(m.icon, color: m.color),
                title: Text(m.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text('${m.lat.toStringAsFixed(4)}, ${m.lng.toStringAsFixed(4)}', style: const TextStyle(color: Colors.grey)),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
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
                colors: [Colors.green.shade900, Colors.blue.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAnalyticStat('Distance', '${_totalDistance.toStringAsFixed(1)} km', Colors.cyan),
                _buildAnalyticStat('Avg Speed', '${_averageSpeed.toStringAsFixed(1)} km/h', Colors.green),
                _buildAnalyticStat('Visits', '${_visits.length}', Colors.orange),
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
                const Text('Location Frequency', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._locationFrequency.entries.map((entry) => ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value} visits', style: const TextStyle(color: Colors.cyan)),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 50,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.cyan,
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
                const Text('Recent Visits', style: TextStyle(color: Colors.white)),
                const Divider(),
                ..._visits.map((visit) => ListTile(
                  leading: const Icon(Icons.location_history, color: Colors.cyan),
                  title: Text(visit.location, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${_formatTime(visit.entry)} - ${_formatTime(visit.exit)}', style: const TextStyle(color: Colors.grey)),
                  trailing: Text('${visit.duration} min', style: const TextStyle(color: Colors.green)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildGeofencingTab() {
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
              _buildGeofenceStat('Active', '${_geofences.where((g) => g.status == 'Active').length}', Colors.green),
              _buildGeofenceStat('Alerts', '${_alerts.length}', Colors.red),
              _buildGeofenceStat('Total', '${_geofences.length}', Colors.blue),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _geofences.length,
            itemBuilder: (ctx, i) {
              final fence = _geofences[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(fence.icon, color: fence.color),
                  title: Text(fence.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Radius: ${fence.radius}m • Status: ${fence.status}', style: const TextStyle(color: Colors.grey)),
                  trailing: Switch(
                    value: fence.status == 'Active',
                    onChanged: (_) {},
                  ),
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
              const Text('Recent Alerts', style: TextStyle(color: Colors.white)),
              const Divider(),
              ..._alerts.map((alert) => ListTile(
                dense: true,
                leading: Icon(alert.icon, color: alert.type == 'Authorized' ? Colors.green : Colors.red),
                title: Text(alert.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text('${alert.location} • ${_formatTime(alert.time)}', style: const TextStyle(color: Colors.grey)),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGeofenceStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildSatelliteTab() {
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
                const Text('Satellites', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._satellites.map((sat) => ListTile(
                  leading: Icon(sat.icon, color: sat.color),
                  title: Text(sat.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Altitude: ${sat.altitude} km • Status: ${sat.status}', style: const TextStyle(color: Colors.grey)),
                  trailing: Text('${sat.accuracy}%', style: const TextStyle(color: Colors.cyan)),
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
                const Text('Weather Data', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._weatherData.entries.map((entry) => ListTile(
                  leading: Icon(Icons.wb_sunny, color: Colors.orange),
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${entry.value.temp}°C • Humidity: ${entry.value.humidity}% • Wind: ${entry.value.wind} km/h', style: const TextStyle(color: Colors.grey)),
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
                const Text('Earthquake Alerts', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._earthquakes.map((eq) => ListTile(
                  leading: const Icon(Icons.earthquake, color: Colors.red),
                  title: Text('Magnitude ${eq.magnitude}', style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${eq.location} • ${_formatDate(eq.time)}', style: const TextStyle(color: Colors.grey)),
                  trailing: Text(eq.severity, style: const TextStyle(color: Colors.red)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class MapMarker {
  final String name;
  double lat;
  double lng;
  final IconData icon;
  final Color color;
  final String description;

  MapMarker(this.name, this.lat, this.lng, this.icon, this.color, this.description);
}

class HeatmapPoint {
  final double lat;
  final double lng;
  final int intensity;

  HeatmapPoint(this.lat, this.lng, this.intensity);
}

class LocationPoint {
  final double lat;
  final double lng;

  LocationPoint(this.lat, this.lng);
}

class RoutePath {
  final String name;
  final List<LocationPoint> points;
  final double distance;
  final Color color;

  RoutePath(this.name, this.points, this.distance, this.color);
}

class LocationVisit {
  final String location;
  final DateTime entry;
  final DateTime exit;
  final int duration;

  LocationVisit(this.location, this.entry, this.exit, this.duration);
}

class Geofence {
  final String name;
  final double lat;
  final double lng;
  final int radius;
  String status;
  final IconData icon;
  final Color color;

  Geofence(this.name, this.lat, this.lng, this.radius, this.status, this.icon, this.color);
}

class GeofenceAlert {
  final String name;
  final String location;
  final DateTime time;
  final String type;
  final IconData icon;

  GeofenceAlert(this.name, this.location, this.time, this.type, this.icon);
}

class Satellite {
  final String name;
  final int altitude;
  final String status;
  final double accuracy;
  final IconData icon;
  final Color color;

  Satellite(this.name, this.altitude, this.status, this.accuracy, this.icon, this.color);
}

class WeatherData {
  final double temp;
  final int humidity;
  final double wind;
  final String condition;

  WeatherData(this.temp, this.humidity, this.wind, this.condition);
}

class Earthquake {
  final double magnitude;
  final String location;
  final DateTime time;
  final double depth;
  final String severity;

  Earthquake(this.magnitude, this.location, this.time, this.depth, this.severity);
}

class MapPainter extends CustomPainter {
  final List<MapMarker> markers;
  final List<RoutePath> routes;

  MapPainter(this.markers, this.routes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.3)..strokeWidth = 2;
    
    // Draw grid
    for (int i = 0; i < 10; i++) {
      canvas.drawLine(Offset(0, size.height * i / 10), Offset(size.width, size.height * i / 10), paint);
      canvas.drawLine(Offset(size.width * i / 10, 0), Offset(size.width * i / 10, size.height), paint);
    }
    
    // Draw routes
    for (var route in routes) {
      if (route.points.isNotEmpty) {
        final startX = (route.points.first.lng - 46.6700) * 10000;
        final startY = (route.points.first.lat - 24.7000) * 10000;
        var path = Path();
        path.moveTo(startX, startY);
        for (int i = 1; i < route.points.length; i++) {
          final x = (route.points[i].lng - 46.6700) * 10000;
          final y = (route.points[i].lat - 24.7000) * 10000;
          path.lineTo(x, y);
        }
        canvas.drawPath(path, Paint()..color = route.color..strokeWidth = 3..style = PaintingStyle.stroke);
      }
    }
    
    // Draw markers
    for (var marker in markers) {
      final x = (marker.lng - 46.6700) * 10000;
      final y = (marker.lat - 24.7000) * 10000;
      canvas.drawCircle(Offset(x, y), 8, Paint()..color = marker.color);
      
      final textPainter = TextPainter(
        text: TextSpan(text: marker.name, style: const TextStyle(color: Colors.white, fontSize: 10)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 15));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
