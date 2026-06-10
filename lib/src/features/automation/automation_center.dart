import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class AutomationCenter extends StatefulWidget {
  const AutomationCenter({super.key});

  @override
  State<AutomationCenter> createState() => _AutomationCenterState();
}

class _AutomationCenterState extends State<AutomationCenter> {
  int _selectedTab = 0;
  
  // Automation Rules
  List<AutomationRule> _rules = [];
  List<AutomationRule> _activeRules = [];
  List<AutomationRule> _inactiveRules = [];
  
  // Scheduled Tasks
  List<ScheduledTask> _scheduledTasks = [];
  List<ScheduledTask> _completedTasks = [];
  bool _isAddingTask = false;
  
  // Workflows
  List<Workflow> _workflows = [];
  List<WorkflowStep> _workflowSteps = [];
  
  // Automation Logs
  List<AutomationLog> _logs = [];
  Timer? _taskChecker;

  @override
  void initState() {
    super.initState();
    _loadRules();
    _loadTasks();
    _loadWorkflows();
    _loadLogs();
    _startTaskChecker();
  }

  void _loadRules() {
    _rules = [
      AutomationRule('R-001', 'Auto-Scan Network', 'daily', 'security', true, 'Scan local network for new devices'),
      AutomationRule('R-002', 'Backup System', 'weekly', 'backup', true, 'Create system backup every Sunday'),
      AutomationRule('R-003', 'Clean Cache', 'hourly', 'maintenance', false, 'Clear temporary files'),
      AutomationRule('R-004', 'Update Signatures', 'daily', 'security', true, 'Update vulnerability database'),
      AutomationRule('R-005', 'Generate Report', 'weekly', 'reporting', true, 'Generate weekly security report'),
    ];
    
    _activeRules = _rules.where((r) => r.enabled).toList();
    _inactiveRules = _rules.where((r) => !r.enabled).toList();
  }

  void _loadTasks() {
    _scheduledTasks = [
      ScheduledTask('T-001', 'Network Scan', DateTime.now().add(const Duration(hours: 2)), 'Pending', 'daily', 'security'),
      ScheduledTask('T-002', 'System Backup', DateTime.now().add(const Duration(hours: 5)), 'Pending', 'weekly', 'backup'),
      ScheduledTask('T-003', 'Report Generation', DateTime.now().add(const Duration(hours: 24)), 'Pending', 'daily', 'reporting'),
    ];
    
    _completedTasks = [
      ScheduledTask('T-004', 'Cache Cleanup', DateTime.now().subtract(const Duration(hours: 3)), 'Completed', 'hourly', 'maintenance'),
      ScheduledTask('T-005', 'Update Signatures', DateTime.now().subtract(const Duration(hours: 12)), 'Completed', 'daily', 'security'),
    ];
  }

  void _loadWorkflows() {
    _workflows = [
      Workflow('W-001', 'Security Response', 'Active', 5, DateTime.now().subtract(const Duration(days: 1))),
      Workflow('W-002', 'Data Backup', 'Active', 3, DateTime.now().subtract(const Duration(days: 3))),
      Workflow('W-003', 'Incident Response', 'Draft', 7, DateTime.now()),
    ];
    
    _workflowSteps = [
      WorkflowStep('1', 'Detect Threat', 'security', 'pending'),
      WorkflowStep('2', 'Analyze Impact', 'analysis', 'pending'),
      WorkflowStep('3', 'Contain Threat', 'response', 'pending'),
      WorkflowStep('4', 'Eradicate', 'response', 'pending'),
      WorkflowStep('5', 'Recover', 'recovery', 'pending'),
      WorkflowStep('6', 'Post-Incident', 'review', 'pending'),
    ];
  }

  void _loadLogs() {
    _logs = [
      AutomationLog('Rule R-001 triggered', DateTime.now().subtract(const Duration(hours: 1)), 'SUCCESS'),
      AutomationLog('Task T-001 completed', DateTime.now().subtract(const Duration(hours: 2)), 'SUCCESS'),
      AutomationLog('Backup failed - storage full', DateTime.now().subtract(const Duration(hours: 5)), 'ERROR'),
      AutomationLog('Rule R-003 executed', DateTime.now().subtract(const Duration(hours: 8)), 'SUCCESS'),
      AutomationLog('Workflow W-001 started', DateTime.now().subtract(const Duration(days: 1)), 'INFO'),
    ];
  }

  void _startTaskChecker() {
    _taskChecker = Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      for (var task in _scheduledTasks) {
        if (task.status == 'Pending' && task.scheduledTime.isBefore(now)) {
          setState(() {
            task.status = 'Running';
          });
          _executeTask(task);
        }
      }
    });
  }

  void _executeTask(ScheduledTask task) {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        task.status = 'Completed';
        _completedTasks.insert(0, task);
        _scheduledTasks.remove(task);
      });
      _addLog('Task ${task.id} completed', 'SUCCESS');
    });
  }

  void _addTask() {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) {
          return AlertDialog(
            title: const Text('Schedule Task'),
            backgroundColor: Colors.grey.shade900,
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: typeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Task Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Schedule Time'),
                    subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}'),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (time != null) {
                          setStateDialog(() {
                            selectedDate = DateTime(
                              date.year, date.month, date.day,
                              time.hour, time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  final newTask = ScheduledTask(
                    'T-${_scheduledTasks.length + _completedTasks.length + 1}',
                    nameController.text,
                    selectedDate,
                    'Pending',
                    typeController.text,
                    'manual',
                  );
                  setState(() {
                    _scheduledTasks.add(newTask);
                  });
                  Navigator.pop(ctx);
                  _addLog('Task ${newTask.id} scheduled', 'INFO');
                },
                child: const Text('Schedule'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleRule(AutomationRule rule) {
    setState(() {
      rule.enabled = !rule.enabled;
      _activeRules = _rules.where((r) => r.enabled).toList();
      _inactiveRules = _rules.where((r) => !r.enabled).toList();
      _addLog('Rule ${rule.id} ${rule.enabled ? 'enabled' : 'disabled'}', 'INFO');
    });
  }

  void _addLog(String message, String status) {
    setState(() {
      _logs.insert(0, AutomationLog(message, DateTime.now(), status));
      if (_logs.length > 50) _logs.removeLast();
    });
  }

  void _runWorkflow(Workflow workflow) {
    setState(() {
      workflow.status = 'Running';
    });
    _addLog('Workflow ${workflow.id} started', 'INFO');
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        workflow.status = 'Completed';
        workflow.lastRun = DateTime.now();
      });
      _addLog('Workflow ${workflow.id} completed', 'SUCCESS');
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
            Tab(icon: Icon(Icons.account_tree), text: 'Workflows'),
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
          _buildWorkflowsTab(),
          _buildLogsTab(),
        ],
      ),
    );
  }

  Widget _buildRulesTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade900,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.play_circle), text: 'Active'),
                Tab(icon: Icon(Icons.pause_circle), text: 'Inactive'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: _activeRules.length,
                  itemBuilder: (ctx, i) {
                    final rule = _activeRules[i];
                    return _buildRuleCard(rule);
                  },
                ),
                ListView.builder(
                  itemCount: _inactiveRules.length,
                  itemBuilder: (ctx, i) {
                    final rule = _inactiveRules[i];
                    return _buildRuleCard(rule);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(AutomationRule rule) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: rule.enabled ? Colors.green : Colors.red, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(rule.id, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(rule.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              Switch(
                value: rule.enabled,
                onChanged: (_) => _toggleRule(rule),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(rule.description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(rule.schedule, style: const TextStyle(color: Colors.blue)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(rule.category, style: const TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _addTask,
            icon: const Icon(Icons.add),
            label: const Text('SCHEDULE NEW TASK'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade900,
                  child: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.pending), text: 'Pending'),
                      Tab(icon: Icon(Icons.check_circle), text: 'Completed'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: _scheduledTasks.length,
                        itemBuilder: (ctx, i) {
                          final task = _scheduledTasks[i];
                          return _buildTaskCard(task);
                        },
                      ),
                      ListView.builder(
                        itemCount: _completedTasks.length,
                        itemBuilder: (ctx, i) {
                          final task = _completedTasks[i];
                          return _buildTaskCard(task);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(ScheduledTask task) {
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
            task.status == 'Completed' ? Icons.check_circle :
            task.status == 'Running' ? Icons.hourglass_empty : Icons.schedule,
            color: task.status == 'Completed' ? Colors.green :
                   task.status == 'Running' ? Colors.orange : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('${task.type} • ${_formatDateTime(task.scheduledTime)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task.status == 'Completed' ? Colors.green.withOpacity(0.2) :
                     task.status == 'Running' ? Colors.orange.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(task.status, style: TextStyle(color: task.status == 'Completed' ? Colors.green : Colors.orange)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowsTab() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: _workflows.length,
            itemBuilder: (ctx, i) {
              final workflow = _workflows[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                        Text(workflow.id, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(workflow.name, style: const TextStyle(color: Colors.white))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: workflow.status == 'Active' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(workflow.status, style: TextStyle(color: workflow.status == 'Active' ? Colors.green : Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${workflow.steps} steps • Last run: ${_formatDate(workflow.lastRun)}',
                      style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    if (workflow.status != 'Running')
                      ElevatedButton(
                        onPressed: () => _runWorkflow(workflow),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        child: const Text('RUN WORKFLOW'),
                      ),
                  ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Workflow Steps', style: TextStyle(color: Colors.white, fontSize: 18)),
              const Divider(),
              ..._workflowSteps.map((step) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: step.status == 'completed' ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                  child: Icon(Icons.check, color: step.status == 'completed' ? Colors.green : Colors.grey),
                ),
                title: Text(step.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text(step.category, style: const TextStyle(color: Colors.grey)),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogsTab() {
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (ctx, i) {
        final log = _logs[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                log.status == 'SUCCESS' ? Icons.check_circle :
                log.status == 'ERROR' ? Icons.error : Icons.info,
                color: log.status == 'SUCCESS' ? Colors.green :
                       log.status == 'ERROR' ? Colors.red : Colors.blue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.message, style: const TextStyle(color: Colors.white)),
                    Text(_formatDateTime(log.timestamp), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text(log.status, style: TextStyle(color: log.status == 'SUCCESS' ? Colors.green : Colors.orange)),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}:${time.second}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class AutomationRule {
  final String id;
  final String name;
  final String schedule;
  final String category;
  bool enabled;
  final String description;

  AutomationRule(this.id, this.name, this.schedule, this.category, this.enabled, this.description);
}

class ScheduledTask {
  final String id;
  final String name;
  final DateTime scheduledTime;
  String status;
  final String type;
  final String category;

  ScheduledTask(this.id, this.name, this.scheduledTime, this.status, this.type, this.category);
}

class Workflow {
  final String id;
  final String name;
  String status;
  final int steps;
  DateTime lastRun;

  Workflow(this.id, this.name, this.status, this.steps, this.lastRun);
}

class WorkflowStep {
  final String id;
  final String name;
  final String category;
  String status;

  WorkflowStep(this.id, this.name, this.category, this.status);
}

class AutomationLog {
  final String message;
  final DateTime timestamp;
  final String status;

  AutomationLog(this.message, this.timestamp, this.status);
}
EOFcd ~/Supernova/project_zion

mkdir -p lib/src/features/automation

cat > lib/src/features/automation/automation_center.dart << 'EOF'
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class AutomationCenter extends StatefulWidget {
  const AutomationCenter({super.key});

  @override
  State<AutomationCenter> createState() => _AutomationCenterState();
}

class _AutomationCenterState extends State<AutomationCenter> {
  int _selectedTab = 0;
  
  // Automation Rules
  List<AutomationRule> _rules = [];
  List<AutomationRule> _activeRules = [];
  List<AutomationRule> _inactiveRules = [];
  
  // Scheduled Tasks
  List<ScheduledTask> _scheduledTasks = [];
  List<ScheduledTask> _completedTasks = [];
  bool _isAddingTask = false;
  
  // Workflows
  List<Workflow> _workflows = [];
  List<WorkflowStep> _workflowSteps = [];
  
  // Automation Logs
  List<AutomationLog> _logs = [];
  Timer? _taskChecker;

  @override
  void initState() {
    super.initState();
    _loadRules();
    _loadTasks();
    _loadWorkflows();
    _loadLogs();
    _startTaskChecker();
  }

  void _loadRules() {
    _rules = [
      AutomationRule('R-001', 'Auto-Scan Network', 'daily', 'security', true, 'Scan local network for new devices'),
      AutomationRule('R-002', 'Backup System', 'weekly', 'backup', true, 'Create system backup every Sunday'),
      AutomationRule('R-003', 'Clean Cache', 'hourly', 'maintenance', false, 'Clear temporary files'),
      AutomationRule('R-004', 'Update Signatures', 'daily', 'security', true, 'Update vulnerability database'),
      AutomationRule('R-005', 'Generate Report', 'weekly', 'reporting', true, 'Generate weekly security report'),
    ];
    
    _activeRules = _rules.where((r) => r.enabled).toList();
    _inactiveRules = _rules.where((r) => !r.enabled).toList();
  }

  void _loadTasks() {
    _scheduledTasks = [
      ScheduledTask('T-001', 'Network Scan', DateTime.now().add(const Duration(hours: 2)), 'Pending', 'daily', 'security'),
      ScheduledTask('T-002', 'System Backup', DateTime.now().add(const Duration(hours: 5)), 'Pending', 'weekly', 'backup'),
      ScheduledTask('T-003', 'Report Generation', DateTime.now().add(const Duration(hours: 24)), 'Pending', 'daily', 'reporting'),
    ];
    
    _completedTasks = [
      ScheduledTask('T-004', 'Cache Cleanup', DateTime.now().subtract(const Duration(hours: 3)), 'Completed', 'hourly', 'maintenance'),
      ScheduledTask('T-005', 'Update Signatures', DateTime.now().subtract(const Duration(hours: 12)), 'Completed', 'daily', 'security'),
    ];
  }

  void _loadWorkflows() {
    _workflows = [
      Workflow('W-001', 'Security Response', 'Active', 5, DateTime.now().subtract(const Duration(days: 1))),
      Workflow('W-002', 'Data Backup', 'Active', 3, DateTime.now().subtract(const Duration(days: 3))),
      Workflow('W-003', 'Incident Response', 'Draft', 7, DateTime.now()),
    ];
    
    _workflowSteps = [
      WorkflowStep('1', 'Detect Threat', 'security', 'pending'),
      WorkflowStep('2', 'Analyze Impact', 'analysis', 'pending'),
      WorkflowStep('3', 'Contain Threat', 'response', 'pending'),
      WorkflowStep('4', 'Eradicate', 'response', 'pending'),
      WorkflowStep('5', 'Recover', 'recovery', 'pending'),
      WorkflowStep('6', 'Post-Incident', 'review', 'pending'),
    ];
  }

  void _loadLogs() {
    _logs = [
      AutomationLog('Rule R-001 triggered', DateTime.now().subtract(const Duration(hours: 1)), 'SUCCESS'),
      AutomationLog('Task T-001 completed', DateTime.now().subtract(const Duration(hours: 2)), 'SUCCESS'),
      AutomationLog('Backup failed - storage full', DateTime.now().subtract(const Duration(hours: 5)), 'ERROR'),
      AutomationLog('Rule R-003 executed', DateTime.now().subtract(const Duration(hours: 8)), 'SUCCESS'),
      AutomationLog('Workflow W-001 started', DateTime.now().subtract(const Duration(days: 1)), 'INFO'),
    ];
  }

  void _startTaskChecker() {
    _taskChecker = Timer.periodic(const Duration(seconds: 30), (timer) {
      final now = DateTime.now();
      for (var task in _scheduledTasks) {
        if (task.status == 'Pending' && task.scheduledTime.isBefore(now)) {
          setState(() {
            task.status = 'Running';
          });
          _executeTask(task);
        }
      }
    });
  }

  void _executeTask(ScheduledTask task) {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        task.status = 'Completed';
        _completedTasks.insert(0, task);
        _scheduledTasks.remove(task);
      });
      _addLog('Task ${task.id} completed', 'SUCCESS');
    });
  }

  void _addTask() {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) {
          return AlertDialog(
            title: const Text('Schedule Task'),
            backgroundColor: Colors.grey.shade900,
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: typeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Task Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Schedule Time'),
                    subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}'),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (time != null) {
                          setStateDialog(() {
                            selectedDate = DateTime(
                              date.year, date.month, date.day,
                              time.hour, time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  final newTask = ScheduledTask(
                    'T-${_scheduledTasks.length + _completedTasks.length + 1}',
                    nameController.text,
                    selectedDate,
                    'Pending',
                    typeController.text,
                    'manual',
                  );
                  setState(() {
                    _scheduledTasks.add(newTask);
                  });
                  Navigator.pop(ctx);
                  _addLog('Task ${newTask.id} scheduled', 'INFO');
                },
                child: const Text('Schedule'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleRule(AutomationRule rule) {
    setState(() {
      rule.enabled = !rule.enabled;
      _activeRules = _rules.where((r) => r.enabled).toList();
      _inactiveRules = _rules.where((r) => !r.enabled).toList();
      _addLog('Rule ${rule.id} ${rule.enabled ? 'enabled' : 'disabled'}', 'INFO');
    });
  }

  void _addLog(String message, String status) {
    setState(() {
      _logs.insert(0, AutomationLog(message, DateTime.now(), status));
      if (_logs.length > 50) _logs.removeLast();
    });
  }

  void _runWorkflow(Workflow workflow) {
    setState(() {
      workflow.status = 'Running';
    });
    _addLog('Workflow ${workflow.id} started', 'INFO');
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        workflow.status = 'Completed';
        workflow.lastRun = DateTime.now();
      });
      _addLog('Workflow ${workflow.id} completed', 'SUCCESS');
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
            Tab(icon: Icon(Icons.account_tree), text: 'Workflows'),
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
          _buildWorkflowsTab(),
          _buildLogsTab(),
        ],
      ),
    );
  }

  Widget _buildRulesTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade900,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.play_circle), text: 'Active'),
                Tab(icon: Icon(Icons.pause_circle), text: 'Inactive'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: _activeRules.length,
                  itemBuilder: (ctx, i) {
                    final rule = _activeRules[i];
                    return _buildRuleCard(rule);
                  },
                ),
                ListView.builder(
                  itemCount: _inactiveRules.length,
                  itemBuilder: (ctx, i) {
                    final rule = _inactiveRules[i];
                    return _buildRuleCard(rule);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(AutomationRule rule) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: rule.enabled ? Colors.green : Colors.red, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(rule.id, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(rule.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              Switch(
                value: rule.enabled,
                onChanged: (_) => _toggleRule(rule),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(rule.description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(rule.schedule, style: const TextStyle(color: Colors.blue)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(rule.category, style: const TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _addTask,
            icon: const Icon(Icons.add),
            label: const Text('SCHEDULE NEW TASK'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade900,
                  child: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.pending), text: 'Pending'),
                      Tab(icon: Icon(Icons.check_circle), text: 'Completed'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: _scheduledTasks.length,
                        itemBuilder: (ctx, i) {
                          final task = _scheduledTasks[i];
                          return _buildTaskCard(task);
                        },
                      ),
                      ListView.builder(
                        itemCount: _completedTasks.length,
                        itemBuilder: (ctx, i) {
                          final task = _completedTasks[i];
                          return _buildTaskCard(task);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(ScheduledTask task) {
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
            task.status == 'Completed' ? Icons.check_circle :
            task.status == 'Running' ? Icons.hourglass_empty : Icons.schedule,
            color: task.status == 'Completed' ? Colors.green :
                   task.status == 'Running' ? Colors.orange : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('${task.type} • ${_formatDateTime(task.scheduledTime)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task.status == 'Completed' ? Colors.green.withOpacity(0.2) :
                     task.status == 'Running' ? Colors.orange.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(task.status, style: TextStyle(color: task.status == 'Completed' ? Colors.green : Colors.orange)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowsTab() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: _workflows.length,
            itemBuilder: (ctx, i) {
              final workflow = _workflows[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                        Text(workflow.id, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(workflow.name, style: const TextStyle(color: Colors.white))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: workflow.status == 'Active' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(workflow.status, style: TextStyle(color: workflow.status == 'Active' ? Colors.green : Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${workflow.steps} steps • Last run: ${_formatDate(workflow.lastRun)}',
                      style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    if (workflow.status != 'Running')
                      ElevatedButton(
                        onPressed: () => _runWorkflow(workflow),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        child: const Text('RUN WORKFLOW'),
                      ),
                  ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Workflow Steps', style: TextStyle(color: Colors.white, fontSize: 18)),
              const Divider(),
              ..._workflowSteps.map((step) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: step.status == 'completed' ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                  child: Icon(Icons.check, color: step.status == 'completed' ? Colors.green : Colors.grey),
                ),
                title: Text(step.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text(step.category, style: const TextStyle(color: Colors.grey)),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogsTab() {
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (ctx, i) {
        final log = _logs[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                log.status == 'SUCCESS' ? Icons.check_circle :
                log.status == 'ERROR' ? Icons.error : Icons.info,
                color: log.status == 'SUCCESS' ? Colors.green :
                       log.status == 'ERROR' ? Colors.red : Colors.blue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.message, style: const TextStyle(color: Colors.white)),
                    Text(_formatDateTime(log.timestamp), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text(log.status, style: TextStyle(color: log.status == 'SUCCESS' ? Colors.green : Colors.orange)),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}:${time.second}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class AutomationRule {
  final String id;
  final String name;
  final String schedule;
  final String category;
  bool enabled;
  final String description;

  AutomationRule(this.id, this.name, this.schedule, this.category, this.enabled, this.description);
}

class ScheduledTask {
  final String id;
  final String name;
  final DateTime scheduledTime;
  String status;
  final String type;
  final String category;

  ScheduledTask(this.id, this.name, this.scheduledTime, this.status, this.type, this.category);
}

class Workflow {
  final String id;
  final String name;
  String status;
  final int steps;
  DateTime lastRun;

  Workflow(this.id, this.name, this.status, this.steps, this.lastRun);
}

class WorkflowStep {
  final String id;
  final String name;
  final String category;
  String status;

  WorkflowStep(this.id, this.name, this.category, this.status);
}

class AutomationLog {
  final String message;
  final DateTime timestamp;
  final String status;

  AutomationLog(this.message, this.timestamp, this.status);
}
