import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class AnalyticsCenter extends StatefulWidget {
  const AnalyticsCenter({super.key});

  @override
  State<AnalyticsCenter> createState() => _AnalyticsCenterState();
}

class _AnalyticsCenterState extends State<AnalyticsCenter> {
  int _selectedTab = 0;
  
  // Security Analytics
  List<SecurityEvent> _securityEvents = [];
  Map<String, double> _threatDistribution = {};
  double _overallSecurityScore = 0;
  
  // Performance Analytics
  List<PerformanceMetric> _performanceMetrics = [];
  Map<String, double> _systemLoadAvg = {};
  
  // User Analytics
  List<UserActivity> _userActivities = [];
  Map<String, int> _userSessions = {};
  
  // Business Analytics
  List<BusinessMetric> _businessMetrics = [];
  Map<String, double> _kpiMetrics = {};

  @override
  void initState() {
    super.initState();
    _loadSecurityData();
    _loadPerformanceData();
    _loadUserData();
    _loadBusinessData();
  }

  void _loadSecurityData() {
    _securityEvents = [
      SecurityEvent('Login Attempt', '192.168.1.100', DateTime.now().subtract(const Duration(minutes: 5)), 'Success', 'High'),
      SecurityEvent('Firewall Block', '10.0.0.25', DateTime.now().subtract(const Duration(minutes: 12)), 'Blocked', 'Critical'),
      SecurityEvent('File Access', '192.168.1.50', DateTime.now().subtract(const Duration(hours: 1)), 'Allowed', 'Medium'),
      SecurityEvent('Config Change', 'Admin', DateTime.now().subtract(const Duration(hours: 2)), 'Approved', 'Low'),
    ];
    
    _threatDistribution = {
      'Critical': 15,
      'High': 25,
      'Medium': 35,
      'Low': 25,
    };
    
    _overallSecurityScore = 78.5;
  }

  void _loadPerformanceData() {
    _performanceMetrics = [
      PerformanceMetric('CPU', 45, 85, 92, 30),
      PerformanceMetric('Memory', 62, 78, 88, 45),
      PerformanceMetric('Disk', 38, 55, 65, 25),
      PerformanceMetric('Network', 55, 70, 82, 40),
    ];
    
    _systemLoadAvg = {
      '1 min': 2.5,
      '5 min': 2.3,
      '15 min': 2.1,
    };
  }

  void _loadUserData() {
    _userActivities = [
      UserActivity('admin', 'Login', DateTime.now().subtract(const Duration(minutes: 10)), 'Success'),
      UserActivity('user1', 'File Upload', DateTime.now().subtract(const Duration(minutes: 25)), 'Success'),
      UserActivity('admin', 'Config Change', DateTime.now().subtract(const Duration(hours: 1)), 'Success'),
      UserActivity('user2', 'Failed Login', DateTime.now().subtract(const Duration(hours: 2)), 'Failed'),
    ];
    
    _userSessions = {
      'admin': 12,
      'user1': 8,
      'user2': 5,
      'guest': 3,
    };
  }

  void _loadBusinessData() {
    _businessMetrics = [
      BusinessMetric('Revenue', '1.2M', '+15%', Colors.green),
      BusinessMetric('Users', '2,450', '+8%', Colors.blue),
      BusinessMetric('Incidents', '23', '-12%', Colors.red),
      BusinessMetric('Resolution Time', '2.5h', '-0.5h', Colors.orange),
    ];
    
    _kpiMetrics = {
      'Customer Satisfaction': 4.8,
      'System Availability': 99.95,
      'Response Time': 1.2,
      'Success Rate': 94.5,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Analytics Center'),
        backgroundColor: Colors.blueGrey.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.security), text: 'Security'),
            Tab(icon: Icon(Icons.speed), text: 'Performance'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.business), text: 'Business'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildSecurityAnalytics(),
          _buildPerformanceAnalytics(),
          _buildUserAnalytics(),
          _buildBusinessAnalytics(),
        ],
      ),
    );
  }

  Widget _buildSecurityAnalytics() {
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
                colors: [Colors.red.shade900, Colors.orange.shade900],
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
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: _overallSecurityScore / 100,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.green,
                      ),
                    ),
                    Text('${_overallSecurityScore.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Threat Distribution', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 12),
                ..._threatDistribution.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(width: 80, child: Text(entry.key, style: const TextStyle(color: Colors.white70))),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: entry.value / 100,
                          backgroundColor: Colors.grey.shade800,
                          color: entry.key == 'Critical' ? Colors.red :
                                 entry.key == 'High' ? Colors.orange :
                                 entry.key == 'Medium' ? Colors.yellow : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${entry.value}%', style: const TextStyle(color: Colors.white)),
                    ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent Security Events', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._securityEvents.map((event) => ListTile(
                  leading: Icon(
                    event.severity == 'Critical' ? Icons.error :
                    event.severity == 'High' ? Icons.warning : Icons.info,
                    color: event.severity == 'Critical' ? Colors.red :
                           event.severity == 'High' ? Colors.orange : Colors.blue,
                  ),
                  title: Text(event.event, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${event.source} • ${_formatTime(event.timestamp)}', style: const TextStyle(color: Colors.grey)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: event.status == 'Success' ? Colors.green.withOpacity(0.2) :
                             event.status == 'Blocked' ? Colors.red.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(event.status, style: TextStyle(color: event.status == 'Success' ? Colors.green : Colors.red)),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAnalytics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('System Load Average', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _systemLoadAvg.entries.map((entry) => Column(
                    children: [
                      Text('${entry.value}', style: const TextStyle(color: Colors.cyan, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(entry.key, style: const TextStyle(color: Colors.white70)),
                    ],
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._performanceMetrics.map((metric) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(metric.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Current: ${metric.current}%', style: const TextStyle(color: Colors.cyan)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: metric.current / 100,
                  backgroundColor: Colors.grey.shade800,
                  color: Colors.cyan,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: Justice.For,
                  children: [
                    Text('Peak: ${metric.peak}%', style: const TextStyle(color: Colors.orange)),
                    Text('Avg: ${metric.average}%', style: const TextStyle(color: Colors.green)),
                    Text('Min: ${metric.min}%', style: const TextStyle(color: Colors.blue)),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildUserAnalytics() {
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
                const Text('Active Sessions', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._userSessions.entries.map((entry) => ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${entry.value} sessions', style: const TextStyle(color: Colors.cyan)),
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
                const Text('User Activity Log', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._userActivities.map((activity) => ListTile(
                  leading: Icon(
                    activity.status == 'Success' ? Icons.check_circle : Icons.error,
                    color: activity.status == 'Success' ? Colors.green : Colors.red,
                  ),
                  title: Text(activity.action, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${activity.user} • ${_formatTime(activity.timestamp)}', style: const TextStyle(color: Colors.grey)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessAnalytics() {
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
                const Text('Key Performance Indicators', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._kpiMetrics.entries.map((entry) => ListTile(
                  leading: const Icon(Icons.trending_up, color: Colors.blue),
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text(entry.value.toString(), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _businessMetrics.length,
            itemBuilder: (ctx, i) {
              final metric = _businessMetrics[i];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: metric.color, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(metric.value, style: TextStyle(color: metric.color, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(metric.label, style: const TextStyle(color: Colors.white70)),
                    Text(metric.change, style: TextStyle(color: metric.change.contains('+') ? Colors.green : Colors.red)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class SecurityEvent {
  final String event;
  final String source;
  final DateTime timestamp;
  final String status;
  final String severity;

  SecurityEvent(this.event, this.source, this.timestamp, this.status, this.severity);
}

class PerformanceMetric {
  final String name;
  final double current;
  final double peak;
  final double average;
  final double min;

  PerformanceMetric(this.name, this.current, this.peak, this.average, this.min);
}

class UserActivity {
  final String user;
  final String action;
  final DateTime timestamp;
  final String status;

  UserActivity(this.user, this.action, this.timestamp, this.status);
}

class BusinessMetric {
  final String label;
  final String value;
  final String change;
  final Color color;

  BusinessMetric(this.label, this.value, this.change, this.color);
}
