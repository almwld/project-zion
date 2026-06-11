import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // info, success, warning, error
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'isRead': isRead,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json['id'],
    title: json['title'],
    message: json['message'],
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'],
    isRead: json['isRead'],
  );
}

class NotificationCenter extends StatefulWidget {
  const NotificationCenter({super.key});

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  List<NotificationItem> _notifications = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _startNotificationSimulation();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('notifications');
    if (saved != null) {
      final List<dynamic> jsonList = [];
      // محاكاة تحميل الإشعارات
    }
    
    // إشعارات تجريبية
    if (_notifications.isEmpty) {
      _notifications = [
        NotificationItem(
          id: '1',
          title: 'System Ready',
          message: 'Zion OS is ready and fully operational',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          type: 'success',
        ),
        NotificationItem(
          id: '2',
          title: 'SI Agent Active',
          message: 'Sentient Intelligence Agent is now monitoring',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          type: 'info',
        ),
        NotificationItem(
          id: '3',
          title: 'Network Scan Complete',
          message: 'Found 5 devices on local network',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          type: 'info',
        ),
      ];
    }
    setState(() {});
  }

  void _startNotificationSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _addRandomNotification();
    });
  }

  void _addRandomNotification() {
    final types = ['info', 'success', 'warning', 'error'];
    final titles = [
      'New Target Discovered',
      'Attack Successful',
      'Vulnerability Found',
      'System Update Available',
      'SI Agent Prediction',
    ];
    final messages = [
      'New device found at 192.168.1.105',
      'Successfully exploited target with EternalBlue',
      'Critical vulnerability detected in web server',
      'New update v3.4 is available for download',
      'High probability of attack on port 445',
    ];
    
    final random = DateTime.now().millisecondsSinceEpoch % 5;
    
    final newNotification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titles[random],
      message: messages[random],
      timestamp: DateTime.now(),
      type: types[random % 4],
    );
    
    setState(() {
      _notifications.insert(0, newNotification);
    });
    _saveNotifications();
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    // حفظ الإشعارات
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = NotificationItem(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          timestamp: _notifications[index].timestamp,
          type: _notifications[index].type,
          isRead: true,
        );
      }
    });
  }

  void _clearAll() {
    setState(() => _notifications.clear());
    _saveNotifications();
  }

  void _clearRead() {
    setState(() {
      _notifications.removeWhere((n) => n.isRead);
    });
    _saveNotifications();
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'success': return Colors.green;
      case 'warning': return Colors.orange;
      case 'error': return Colors.red;
      default: return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'success': return Icons.check_circle;
      case 'warning': return Icons.warning;
      case 'error': return Icons.error;
      default: return Icons.info;
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notification Center'),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
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
      body: _notifications.isEmpty
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
              itemCount: _notifications.length,
              itemBuilder: (ctx, i) {
                final notification = _notifications[i];
                return Dismissible(
                  key: Key(notification.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() => _notifications.removeAt(i));
                    _saveNotifications();
                  },
                  child: Card(
                    color: notification.isRead ? Colors.grey.shade900 : Colors.grey.shade800,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      onTap: () => _markAsRead(notification.id),
                      leading: CircleAvatar(
                        backgroundColor: _getTypeColor(notification.type).withOpacity(0.2),
                        child: Icon(_getTypeIcon(notification.type), color: _getTypeColor(notification.type)),
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
                      trailing: Text(
                        _formatTime(notification.timestamp),
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
