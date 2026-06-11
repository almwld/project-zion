import 'package:flutter/material.dart';
import 'dart:async';

class AdvancedTaskManager extends StatefulWidget {
  const AdvancedTaskManager({super.key});

  @override
  State<AdvancedTaskManager> createState() => _AdvancedTaskManagerState();
}

class _AdvancedTaskManagerState extends State<AdvancedTaskManager> {
  final List<Task> _tasks = [];
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskCommandController = TextEditingController();
  String _selectedPriority = 'Normal';
  String _selectedCategory = 'System';
  DateTime? _selectedDateTime;
  Timer? _taskTimer;

  final List<String> _priorities = ['Low', 'Normal', 'High', 'Critical'];
  final List<String> _categories = ['System', 'Network', 'Security', 'Cleanup', 'Backup', 'Custom'];

  @override
  void initState() {
    super.initState();
    _loadSampleTasks();
    _startTaskChecker();
  }

  void _loadSampleTasks() {
    _tasks.addAll([
      Task(
        id: '1',
        name: 'Network Scan',
        command: 'scan 192.168.1.0/24',
        priority: 'High',
        category: 'Network',
        scheduledTime: DateTime.now().add(const Duration(minutes: 5)),
        status: 'Pending',
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        name: 'System Backup',
        command: 'backup system',
        priority: 'Normal',
        category: 'Backup',
        scheduledTime: DateTime.now().add(const Duration(hours: 1)),
        status: 'Pending',
        createdAt: DateTime.now(),
      ),
      Task(
        id: '3',
        name: 'Cache Cleanup',
        command: 'clean cache',
        priority: 'Low',
        category: 'Cleanup',
        scheduledTime: DateTime.now().add(const Duration(hours: 2)),
        status: 'Pending',
        createdAt: DateTime.now(),
      ),
    ]);
  }

  void _startTaskChecker() {
    _taskTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkPendingTasks();
    });
  }

  void _checkPendingTasks() {
    final now = DateTime.now();
    for (var task in _tasks) {
      if (task.status == 'Pending' && task.scheduledTime.isBefore(now)) {
        setState(() {
          task.status = 'Running';
        });
        _executeTask(task);
      }
    }
  }

  void _executeTask(Task task) {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        task.status = 'Completed';
        task.completedAt = DateTime.now();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task "${task.name}" completed successfully!')),
      );
    });
  }

  void _addTask() {
    if (_taskNameController.text.isEmpty || _taskCommandController.text.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _taskNameController.text,
      command: _taskCommandController.text,
      priority: _selectedPriority,
      category: _selectedCategory,
      scheduledTime: _selectedDateTime!,
      status: 'Pending',
      createdAt: DateTime.now(),
    );

    setState(() {
      _tasks.add(newTask);
    });

    _taskNameController.clear();
    _taskCommandController.clear();
    _selectedDateTime = null;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added successfully')),
    );
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  void _cancelTask(String id) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1 && _tasks[index].status == 'Pending') {
        _tasks[index].status = 'Cancelled';
      }
    });
  }

  void _retryTask(String id) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1 && _tasks[index].status == 'Failed') {
        _tasks[index].status = 'Pending';
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Normal': return Colors.blue;
      default: return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed': return Colors.green;
      case 'Running': return Colors.blue;
      case 'Failed': return Colors.red;
      case 'Cancelled': return Colors.grey;
      default: return Colors.orange;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Network': return Icons.network_check;
      case 'Security': return Icons.security;
      case 'Cleanup': return Icons.cleaning_services;
      case 'Backup': return Icons.backup;
      case 'System': return Icons.android;
      default: return Icons.task;
    }
  }

  @override
  void dispose() {
    _taskTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.teal.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAddTaskCard()),
          SliverToBoxAdapter(child: _buildTasksList()),
        ],
      ),
    );
  }

  Widget _buildAddTaskCard() {
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
          const Text('Schedule New Task', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _taskNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Task Name',
              labelStyle: TextStyle(color: Colors.teal),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _taskCommandController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Command',
              labelStyle: TextStyle(color: Colors.teal),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  items: _priorities.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (v) => setState(() => _selectedPriority = v!),
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDateTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _selectedDateTime != null
                          ? '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}'
                          : 'Select Date & Time',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text('SCHEDULE'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    if (_tasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No scheduled tasks', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tasks.length,
      itemBuilder: (ctx, i) {
        final task = _tasks[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            leading: Icon(_getCategoryIcon(task.category), color: _getPriorityColor(task.priority)),
            title: Text(task.name, style: const TextStyle(color: Colors.white)),
            subtitle: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(task.status, style: TextStyle(color: _getStatusColor(task.status), fontSize: 11)),
                ),
                const SizedBox(width: 8),
                Text(_formatDateTime(task.scheduledTime), style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.status == 'Pending')
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => _cancelTask(task.id),
                  ),
                if (task.status == 'Failed')
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () => _retryTask(task.id),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () => _deleteTask(task.id),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Command: ${task.command}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text('Created: ${_formatDateTime(task.createdAt)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    if (task.completedAt != null)
                      Text('Completed: ${_formatDateTime(task.completedAt!)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class Task {
  final String id;
  final String name;
  final String command;
  final String priority;
  final String category;
  final DateTime scheduledTime;
  String status;
  final DateTime createdAt;
  DateTime? completedAt;

  Task({
    required this.id,
    required this.name,
    required this.command,
    required this.priority,
    required this.category,
    required this.scheduledTime,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });
}
