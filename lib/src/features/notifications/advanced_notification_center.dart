import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AdvancedNotificationCenter extends StatefulWidget {
  const AdvancedNotificationCenter({super.key});

  @override
  State<AdvancedNotificationCenter> createState() => _AdvancedNotificationCenterState();
}

class _AdvancedNotificationCenterState extends State<AdvancedNotificationCenter> {
  List<NotificationItem> _notifications = [];
  String _selectedFilter = 'All';
  bool _isLoading = true;
  late Timer _notificationTimer;

  final List<String> _filters = ['All', 'System', 'Security', 'Network', 'SI Agent', 'App'];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _startNotificationSimulation();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('notifications');
    
    if (saved != null && saved.isNotEmpty) {
      _notifications = saved.map((n) => NotificationItem.fromJson(n)).toList();
    } else {
      _notifications = [
        NotificationItem(
          id: '1',
          title: 'System Ready',
          message: 'Zion OS v3.3 is now fully operational',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          type: 'System',
          priority: 'Normal',
          isRead: false,
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        NotificationItem(
          id: '2',
          title: 'Security Alert',
          message: 'New vulnerability detected in network',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          type: 'Security',
          priority: 'High',
          isRead: false,
          icon: Icons.warning,
          color: Colors.red,
        ),
        NotificationItem(
          id: '3',
          title: 'SI Agent Active',
          message: 'AI monitoring started on local network',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          type: 'SI Agent',
          priority: 'Normal',
          isRead: true,
          icon: Icons.psychology,
          color: Colors.purple,
        ),
        NotificationItem(
          id: '4',
          title: 'Network Scan Complete',
          message: 'Found 12 devices on your network',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: 'Network',
          priority: 'Low',
          isRead: true,
          icon: Icons.network_check,
          color: Colors.cyan,
        ),
      ];
    }
    
    setState(() => _isLoading = false);
  }

  void _startNotificationSimulation() {
    _notificationTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
      _addRandomNotification();
    });
  }

  void _addRandomNotification() {
    final randomTypes = ['System', 'Security', 'Network', 'SI Agent', 'App'];
    final randomType = randomTypes[DateTime.now().millisecondsSinceEpoch % randomTypes.length];
    
    final newNotification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _getRandomTitle(randomType),
      message: _getRandomMessage(randomType),
      timestamp: DateTime.now(),
      type: randomType,
      priority: _getRandomPriority(),
      isRead: false,
      icon: _getIconForType(randomType),
      color: _getColorForType(randomType),
    );
    
    setState(() {
      _notifications.insert(0, newNotification);
    });
    _saveNotifications();
  }

  String _getRandomTitle(String type) {
    switch (type) {
      case 'System': return 'System Update Available';
      case 'Security': return 'Security Threat Detected';
      case 'Network': return 'New Device Connected';
      case 'SI Agent': return 'AI Prediction Ready';
      default: return 'App Update';
    }
  }

  String _getRandomMessage(String type) {
    switch (type) {
      case 'System': return 'Version 3.4 is ready to install';
      case 'Security': return 'Suspicious activity detected on port 445';
      case 'Network': return 'New device joined your network (192.168.1.105)';
      case 'SI Agent': return 'High probability of attack on port 22';
      default: return 'Application update available';
    }
  }

  String _getRandomPriority() {
    final priorities = ['Low', 'Normal', 'High', 'Critical'];
    return priorities[DateTime.now().millisecondsSinceEpoch % priorities.length];
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'System': return Icons.android;
      case 'Security': return Icons.security;
      case 'Network': return Icons.wifi;
      case 'SI Agent': return Icons.psychology;
      default: return Icons.apps;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'System': return Colors.blue;
      case 'Security': return Colors.red;
      case 'Network': return Colors.cyan;
      case 'SI Agent': return Colors.purple;
      default: return Colors.orange;
    }
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _notifications.map((n) => n.toJson()).toList();
    await prefs.setStringList('notifications', jsonList);
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].isRead = true;
      }
    });
    _saveNotifications();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
    _saveNotifications();
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
    _saveNotifications();
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
    _saveNotifications();
  }

  void _clearRead() {
    setState(() {
      _notifications.removeWhere((n) => n.isRead);
    });
    _saveNotifications();
  }

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications.where((n) => n.type == _selectedFilter).toList();
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${(diff.inDays / 7).floor()} weeks ago';
  }

  @override
  void dispose() {
    _notificationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notification Center'),
            if (_unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$_unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearRead,
            tooltip: 'Clear read',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearAll,
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNotifications.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none, color: Colors.grey, size: 64),
                            SizedBox(height: 16),
                            Text('No notifications', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredNotifications.length,
                        itemBuilder: (ctx, i) {
                          final notification = _filteredNotifications[i];
                          return Dismissible(
                            key: Key(notification.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => _deleteNotification(notification.id),
                            child: GestureDetector(
                              onTap: () => _markAsRead(notification.id),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: notification.isRead ? Colors.grey.shade900 : Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(12),
                                  border: notification.priority == 'Critical'
                                      ? Border.all(color: Colors.red, width: 1)
                                      : notification.priority == 'High'
                                          ? Border.all(color: Colors.orange, width: 1)
                                          : null,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: notification.color.withOpacity(0.2),
                                    child: Icon(notification.icon, color: notification.color),
                                  ),
                                  title: Text(
                                    notification.title,
                                    style: TextStyle(
                                      color: notification.isRead ? Colors.white70 : Colors.white,
                                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    notification.message,
                                    style: const TextStyle(color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatTime(notification.timestamp),
                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      if (notification.priority != 'Normal')
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: notification.priority == 'Critical'
                                                ? Colors.red.withOpacity(0.2)
                                                : notification.priority == 'High'
                                                    ? Colors.orange.withOpacity(0.2)
                                                    : Colors.blue.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            notification.priority,
                                            style: TextStyle(
                                              color: notification.priority == 'Critical'
                                                  ? Colors.red
                                                  : notification.priority == 'High'
                                                      ? Colors.orange
                                                      : Colors.blue,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (ctx, i) {
          final filter = _filters[i];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
              },
              backgroundColor: Colors.grey.shade800,
              selectedColor: Colors.blue,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String id;
  String title;
  String message;
  final DateTime timestamp;
  final String type;
  final String priority;
  bool isRead;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.priority,
    required this.isRead,
    required this.icon,
    required this.color,
  });

  String toJson() {
    return '$id|$title|$message|${timestamp.toIso8601String()}|$type|$priority|$isRead';
  }

  factory NotificationItem.fromJson(String json) {
    final parts = json.split('|');
    return NotificationItem(
      id: parts[0],
      title: parts[1],
      message: parts[2],
      timestamp: DateTime.parse(parts[3]),
      type: parts[4],
      priority: parts[5],
      isRead: parts[6] == 'true',
      icon: Icons.notifications,
      color: Colors.blue,
    );
  }
}
