import 'package:flutter/material.dart';
import 'dart:async';

class AutomationCenter extends StatefulWidget {
  const AutomationCenter({super.key});

  @override
  State<AutomationCenter> createState() => _AutomationCenterState();
}

class _AutomationCenterState extends State<AutomationCenter> {
  int _selectedTab = 0;
  
  List<Map<String, dynamic>> _rules = [];
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _logs = [];
  Timer? _taskChecker;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startTaskChecker();
  }

  void _loadData() {
    _rules = [
      {'id': 'R-001', 'name': 'Auto-Scan Network', 'enabled': true, 'schedule': 'daily'},
      {'id': 'R-002', 'name': 'Backup System', 'enabled': true, 'schedule': 'weekly'},
      {'id': 'R-003', 'name': 'Clean Cache', 'enabled': false, 'schedule': 'hourly'},
    ];
    
    _tasks = [
      {'id': 'T-001', 'name': 'Network Scan', 'time': DateTime.now().add(const Duration(hours: 2)), 'status': 'Pending'},
      {'id': 'T-002', 'name': 'System Backup', 'time': DateTime.now().add(const Duration(hours: 5)), 'status': 'Pending'},
    ];
    
    _logs = [
      {'message': 'System started', 'time': DateTime.now().subtract(const Duration(hours: 1)), 'status': 'SUCCESS'},
      {'message': 'Auto-scan completed', 'time': DateTime.now().subtract(const Duration(hours: 2)), 'status': 'SUCCESS'},
    ];
  }

  void _startTaskChecker() {
    _taskChecker = Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      for (var i = 0; i < _tasks.length; i++) {
        if (_tasks[i]['status'] == 'Pending' && (_tasks[i]['time'] as DateTime).isBefore(now)) {
          _tasks[i]['status'] = 'Completed';
          _logs.insert(0, {'message': 'Task ${_tasks[i]['name']} completed', 'time': DateTime.now(), 'status': 'SUCCESS'});
          if (_logs.length > 20) _logs.removeLast();
          setState(() {});
        }
      }
    });
  }

  void _toggleRule(int index) {
    setState(() {
      _rules[index]['enabled'] = !_rules[index]['enabled'];
    });
  }

  @override
  void dispose() {
    _taskChecker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Automation Center'),
        backgroundColor: Colors.amber.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: 'Rules'),
            Tab(icon: Icon(Icons.schedule), text: 'Tasks'),
            Tab(icon: Icon(Icons.history), text: 'Logs'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildRulesTab(),
          _buildTasksTab(),
          _buildLogsTab(),
        ],
      ),
    );
  }

  Widget _buildRulesTab() {
    return ListView.builder(
      itemCount: _rules.length,
      itemBuilder: (ctx, i) {
        final rule = _rules[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rule['id'], style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    Text(rule['name'], style: const TextStyle(color: Colors.white)),
                    Text(rule['schedule'], style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Switch(
                value: rule['enabled'],
                onChanged: (_) => _toggleRule(i),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTasksTab() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (ctx, i) {
        final task = _tasks[i];
        final time = task['time'] as DateTime;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                task['status'] == 'Completed' ? Icons.check_circle : Icons.schedule,
                color: task['status'] == 'Completed' ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['name'], style: const TextStyle(color: Colors.white)),
                    Text('${time.day}/${time.month} ${time.hour}:${time.minute}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: task['status'] == 'Completed' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(task['status'], style: TextStyle(color: task['status'] == 'Completed' ? Colors.green : Colors.orange)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogsTab() {
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (ctx, i) {
        final log = _logs[i];
        final time = log['time'] as DateTime;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                log['status'] == 'SUCCESS' ? Icons.check_circle : Icons.error,
                color: log['status'] == 'SUCCESS' ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log['message'], style: const TextStyle(color: Colors.white)),
                    Text('${time.hour}:${time.minute}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text(log['status'], style: TextStyle(color: log['status'] == 'SUCCESS' ? Colors.green : Colors.red)),
            ],
          ),
        );
      },
    );
  }
}
