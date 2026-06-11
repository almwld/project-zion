import 'package:flutter/material.dart';
import 'dart:async';

class ProductivityCenter extends StatefulWidget {
  const ProductivityCenter({super.key});

  @override
  State<ProductivityCenter> createState() => _ProductivityCenterState();
}

class _ProductivityCenterState extends State<ProductivityCenter> {
  int _selectedTab = 0;
  
  // Notes
  List<Note> _notes = [];
  final TextEditingController _noteController = TextEditingController();
  String _selectedNoteId = '';
  
  // Tasks
  List<TaskItem> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  
  // Calendar
  DateTime _selectedDate = DateTime.now();
  List<CalendarEvent> _events = [];
  
  // Timer
  int _timerSeconds = 0;
  Timer? _timer;
  bool _isTimerRunning = false;
  int _pomodoroCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _notes = [
      Note(id: '1', title: 'Welcome to Zion OS', content: 'This is your first note. Start writing!', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Note(id: '2', title: 'Meeting Notes', content: 'Discuss new features for v3.4', createdAt: DateTime.now().subtract(const Duration(days: 1)), updatedAt: DateTime.now().subtract(const Duration(days: 1))),
      Note(id: '3', title: 'Project Ideas', content: 'Add AI-powered attack suggestions', createdAt: DateTime.now().subtract(const Duration(days: 2)), updatedAt: DateTime.now().subtract(const Duration(days: 2))),
    ];
    
    _tasks = [
      TaskItem(id: '1', title: 'Review pull requests', completed: false, priority: 'High', dueDate: DateTime.now().add(const Duration(days: 1))),
      TaskItem(id: '2', title: 'Update documentation', completed: false, priority: 'Medium', dueDate: DateTime.now().add(const Duration(days: 2))),
      TaskItem(id: '3', title: 'Test new features', completed: true, priority: 'Low', dueDate: DateTime.now().subtract(const Duration(days: 1))),
    ];
    
    _events = [
      CalendarEvent(id: '1', title: 'Team Meeting', date: DateTime.now(), time: '10:00 AM', duration: '1 hour'),
      CalendarEvent(id: '2', title: 'Code Review', date: DateTime.now().add(const Duration(days: 1)), time: '2:00 PM', duration: '30 min'),
    ];
  }

  void _addNote() {
    if (_noteController.text.isEmpty) return;
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Note ${_notes.length + 1}',
      content: _noteController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    setState(() {
      _notes.insert(0, newNote);
      _noteController.clear();
    });
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((n) => n.id == id);
    });
  }

  void _addTask() {
    if (_taskController.text.isEmpty) return;
    final newTask = TaskItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _taskController.text,
      completed: false,
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    );
    setState(() {
      _tasks.insert(0, newTask);
      _taskController.clear();
    });
  }

  void _toggleTask(String id) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index].completed = !_tasks[index].completed;
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  void _startPomodoro() {
    _timerSeconds = 25 * 60; // 25 minutes
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
          _pomodoroCount++;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pomodoro completed! Take a break.')),
          );
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _timerSeconds = 0;
    });
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Productivity Center'),
        backgroundColor: Colors.orange.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.edit_note), text: 'Notes'),
            Tab(icon: Icon(Icons.checklist), text: 'Tasks'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Calendar'),
            Tab(icon: Icon(Icons.timer), text: 'Pomodoro'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildNotesTab(),
          _buildTasksTab(),
          _buildCalendarTab(),
          _buildPomodoroTab(),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Write a note...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.orange),
                onPressed: _addNote,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _notes.length,
            itemBuilder: (ctx, i) {
              final note = _notes[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(note.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    '${note.content.substring(0, note.content.length > 50 ? 50 : note.content.length)}...',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNote(note.id),
                  ),
                  onTap: () => _showNoteDetail(note),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showNoteDetail(Note note) {
    final controller = TextEditingController(text: note.content);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(note.title),
        backgroundColor: Colors.grey.shade900,
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: 10,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                note.content = controller.text;
                note.updatedAt = DateTime.now();
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Add a task...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.orange),
                onPressed: _addTask,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (ctx, i) {
              final task = _tasks[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (_) => _toggleTask(task.id),
                    activeColor: Colors.green,
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      color: task.completed ? Colors.grey : Colors.white,
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    'Due: ${task.dueDate.day}/${task.dueDate.month} • Priority: ${task.priority}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(task.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.event, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'Events for ${_selectedDate.day}/${_selectedDate.month}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _events.where((e) => e.date.day == _selectedDate.day && e.date.month == _selectedDate.month).length,
            itemBuilder: (ctx, i) {
              final events = _events.where((e) => e.date.day == _selectedDate.day && e.date.month == _selectedDate.month).toList();
              final event = events[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.circle, color: Colors.orange),
                  title: Text(event.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${event.time} • ${event.duration}', style: const TextStyle(color: Colors.grey)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPomodoroTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _formatTimer(_timerSeconds),
                style: const TextStyle(color: Colors.orange, fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isTimerRunning && _timerSeconds == 0)
                ElevatedButton.icon(
                  onPressed: _startPomodoro,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              if (_isTimerRunning)
                ElevatedButton.icon(
                  onPressed: _stopTimer,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Completed Sessions: $_pomodoroCount',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            '25 min work • 5 min break',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class Note {
  final String id;
  final String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

class TaskItem {
  final String id;
  final String title;
  bool completed;
  final String priority;
  final DateTime dueDate;

  TaskItem({
    required this.id,
    required this.title,
    required this.completed,
    required this.priority,
    required this.dueDate,
  });
}

class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String duration;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
  });
}
