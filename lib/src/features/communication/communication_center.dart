import 'package:flutter/material.dart';
import 'dart:async';

class CommunicationCenter extends StatefulWidget {
  const CommunicationCenter({super.key});

  @override
  State<CommunicationCenter> createState() => _CommunicationCenterState();
}

class _CommunicationCenterState extends State<CommunicationCenter> {
  int _selectedTab = 0;
  
  // Messages
  List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  String _selectedContact = 'John Doe';
  
  // Contacts
  List<Contact> _contacts = [];
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  
  // Calls
  bool _isInCall = false;
  Timer? _callTimer;
  int _callDuration = 0;
  
  // Notifications
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadContacts();
    _loadNotifications();
  }

  void _loadMessages() {
    _messages = [
      Message(
        id: '1',
        sender: 'John Doe',
        content: 'Hey, are you there?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: true,
        isMe: false,
      ),
      Message(
        id: '2',
        sender: 'Me',
        content: 'Yes, I\'m here. What\'s up?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        isRead: true,
        isMe: true,
      ),
      Message(
        id: '3',
        sender: 'John Doe',
        content: 'Check out the new update!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isRead: false,
        isMe: false,
      ),
    ];
  }

  void _loadContacts() {
    _contacts = [
      Contact(id: '1', name: 'John Doe', email: 'john@example.com', avatar: Icons.person, color: Colors.blue, status: 'online'),
      Contact(id: '2', name: 'Jane Smith', email: 'jane@example.com', avatar: Icons.person, color: Colors.pink, status: 'away'),
      Contact(id: '3', name: 'Tech Support', email: 'support@zion-os.com', avatar: Icons.support_agent, color: Colors.green, status: 'online'),
    ];
  }

  void _loadNotifications() {
    _notifications = [
      NotificationItem('New message from John Doe', DateTime.now().subtract(const Duration(minutes: 2)), 'message'),
      NotificationItem('System update available', DateTime.now().subtract(const Duration(hours: 1)), 'system'),
      NotificationItem('SI Agent detected suspicious activity', DateTime.now().subtract(const Duration(hours: 3)), 'security'),
    ];
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'Me',
      content: _messageController.text,
      timestamp: DateTime.now(),
      isRead: true,
      isMe: true,
    );
    
    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });
    
    // Simulate reply
    Future.delayed(const Duration(seconds: 2), () {
      final reply = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: _selectedContact,
        content: 'Thanks for your message!',
        timestamp: DateTime.now(),
        isRead: false,
        isMe: false,
      );
      setState(() => _messages.add(reply));
    });
  }

  void _addContact() {
    if (_contactNameController.text.isEmpty) return;
    
    final newContact = Contact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _contactNameController.text,
      email: _contactEmailController.text,
      avatar: Icons.person,
      color: Colors.cyan,
      status: 'offline',
    );
    
    setState(() {
      _contacts.add(newContact);
      _contactNameController.clear();
      _contactEmailController.clear();
    });
  }

  void _startCall() {
    setState(() {
      _isInCall = true;
      _callDuration = 0;
    });
    
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _callDuration++);
    });
  }

  void _endCall() {
    _callTimer?.cancel();
    setState(() {
      _isInCall = false;
      _callDuration = 0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Communications'),
        backgroundColor: Colors.green.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.chat), text: 'Messages'),
            Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
            Tab(icon: Icon(Icons.phone), text: 'Calls'),
            Tab(icon: Icon(Icons.notifications), text: 'Alerts'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildMessagesTab(),
          _buildContactsTab(),
          _buildCallsTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('Chat with:', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _selectedContact,
                items: _contacts.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                onChanged: (v) => setState(() => _selectedContact = v!),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (ctx, i) {
              final msg = _messages.reversed.toList()[i];
              return Align(
                alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: msg.isMe ? Colors.green.shade800 : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(msg.content, style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        '${msg.timestamp.hour}:${msg.timestamp.minute}',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            border: Border(top: BorderSide(color: Colors.green.shade700)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactsTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _contactNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Contact name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _contactEmailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: _addContact,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (ctx, i) {
              final contact = _contacts[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: contact.color.withOpacity(0.2),
                    child: Icon(contact.avatar, color: contact.color),
                  ),
                  title: Text(contact.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(contact.email, style: const TextStyle(color: Colors.grey)),
                  trailing: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: contact.status == 'online' ? Colors.green :
                             contact.status == 'away' ? Colors.orange : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCallsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(Icons.phone, size: 50, color: Colors.green),
          ),
          const SizedBox(height: 24),
          const Text('Calling...', style: TextStyle(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 8),
          Text(_selectedContact, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Text(_formatDuration(_callDuration), style: const TextStyle(color: Colors.green, fontSize: 32)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isInCall)
                ElevatedButton.icon(
                  onPressed: _startCall,
                  icon: const Icon(Icons.call),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              if (_isInCall)
                ElevatedButton.icon(
                  onPressed: _endCall,
                  icon: const Icon(Icons.call_end),
                  label: const Text('End Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (ctx, i) {
        final notif = _notifications[i];
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Icon(
              notif.type == 'message' ? Icons.message :
              notif.type == 'system' ? Icons.settings :
              Icons.warning,
              color: notif.type == 'message' ? Colors.blue :
                     notif.type == 'system' ? Colors.orange : Colors.red,
            ),
            title: Text(notif.message, style: const TextStyle(color: Colors.white)),
            subtitle: Text(_formatTime(notif.time), style: const TextStyle(color: Colors.grey)),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    return '${diff.inHours} hours ago';
  }
}

class Message {
  final String id;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool isMe;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.isMe,
  });
}

class Contact {
  final String id;
  final String name;
  final String email;
  final IconData avatar;
  final Color color;
  final String status;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.color,
    required this.status,
  });
}

class NotificationItem {
  final String message;
  final DateTime time;
  final String type;

  NotificationItem(this.message, this.time, this.type);
}
