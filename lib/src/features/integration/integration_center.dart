import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class IntegrationCenter extends StatefulWidget {
  const IntegrationCenter({super.key});

  @override
  State<IntegrationCenter> createState() => _IntegrationCenterState();
}

class _IntegrationCenterState extends State<IntegrationCenter> {
  int _selectedTab = 0;
  
  // API Integrations
  List<APIIntegration> _apis = [];
  bool _isTestingAPI = false;
  String _apiTestResult = '';
  
  // Webhook Manager
  List<Webhook> _webhooks = [];
  final TextEditingController _webhookUrlController = TextEditingController();
  final TextEditingController _webhookNameController = TextEditingController();
  
  // External Services
  List<ExternalService> _services = [];
  
  // Data Sync
  bool _isSyncing = false;
  DateTime _lastSync = DateTime.now();
  int _syncedRecords = 0;
  List<SyncLog> _syncLogs = [];

  @override
  void initState() {
    super.initState();
    _loadAPIs();
    _loadWebhooks();
    _loadServices();
    _loadSyncLogs();
  }

  void _loadAPIs() {
    _apis = [
      APIIntegration('Shodan', 'Security Intelligence', 'Connected', 'api.shodan.io', '*****'),
      APIIntegration('VirusTotal', 'Malware Analysis', 'Connected', 'www.virustotal.com', '*****'),
      APIIntegration('AlienVault OTX', 'Threat Intelligence', 'Pending', 'otx.alienvault.com', ''),
      APIIntegration('Censys', 'Network Scanning', 'Disconnected', 'search.censys.io', ''),
    ];
  }

  void _loadWebhooks() {
    _webhooks = [
      Webhook('Security Alerts', 'https://webhook.site/alerts', 'Active', DateTime.now().subtract(const Duration(minutes: 5))),
      Webhook('System Events', 'https://webhook.site/events', 'Active', DateTime.now().subtract(const Duration(hours: 2))),
      Webhook('Attack Reports', 'https://webhook.site/attacks', 'Inactive', DateTime.now().subtract(const Duration(days: 1))),
    ];
  }

  void _loadServices() {
    _services = [
      ExternalService('Slack', 'Team Communication', 'Connected', Icons.chat, Colors.blue),
      ExternalService('Discord', 'Community', 'Connected', Icons.headset, Colors.purple),
      ExternalService('Telegram', 'Bot Notifications', 'Pending', Icons.telegram, Colors.cyan),
      ExternalService('Email', 'SMTP Reports', 'Connected', Icons.email, Colors.red),
    ];
  }

  void _loadSyncLogs() {
    _syncLogs = [
      SyncLog(DateTime.now().subtract(const Duration(hours: 1)), 'SUCCESS', 'Threat intelligence synced', 1250),
      SyncLog(DateTime.now().subtract(const Duration(days: 1)), 'SUCCESS', 'Vulnerability database updated', 3400),
      SyncLog(DateTime.now().subtract(const Duration(days: 2)), 'WARNING', 'Partial sync - rate limited', 2300),
    ];
    _syncedRecords = 1250;
  }

  Future<void> _testAPI(APIIntegration api) async {
    setState(() {
      _isTestingAPI = true;
      _apiTestResult = '';
    });

    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isTestingAPI = false;
      _apiTestResult = '✅ API connection successful! Response time: 234ms';
    });
  }

  void _connectAPI(APIIntegration api) {
    setState(() {
      api.status = 'Connected';
      api.apiKey = '•••••';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${api.name} connected successfully!')),
    );
  }

  void _disconnectAPI(APIIntegration api) {
    setState(() {
      api.status = 'Disconnected';
      api.apiKey = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${api.name} disconnected')),
    );
  }

  void _addWebhook() {
    if (_webhookNameController.text.isEmpty || _webhookUrlController.text.isEmpty) return;
    
    final newWebhook = Webhook(
      _webhookNameController.text,
      _webhookUrlController.text,
      'Active',
      DateTime.now(),
    );
    
    setState(() {
      _webhooks.add(newWebhook);
      _webhookNameController.clear();
      _webhookUrlController.clear();
    });
  }

  void _toggleWebhook(Webhook webhook) {
    setState(() {
      webhook.status = webhook.status == 'Active' ? 'Inactive' : 'Active';
    });
  }

  void _deleteWebhook(Webhook webhook) {
    setState(() {
      _webhooks.remove(webhook);
    });
  }

  void _connectService(ExternalService service) {
    setState(() {
      service.status = 'Connected';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${service.name} connected!')),
    );
  }

  void _disconnectService(ExternalService service) {
    setState(() {
      service.status = 'Disconnected';
    });
  }

  Future<void> _syncData() async {
    setState(() {
      _isSyncing = true;
    });

    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _isSyncing = false;
      _lastSync = DateTime.now();
      _syncedRecords += 3400;
      _syncLogs.insert(0, SyncLog(_lastSync, 'SUCCESS', 'Data synchronization completed', 3400));
      if (_syncLogs.length > 10) _syncLogs.removeLast();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data sync completed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Integration Center'),
        backgroundColor: Colors.deepPurple.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.api), text: 'APIs'),
            Tab(icon: Icon(Icons.webhook), text: 'Webhooks'),
            Tab(icon: Icon(Icons.cloud), text: 'Services'),
            Tab(icon: Icon(Icons.sync), text: 'Data Sync'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildAPITab(),
          _buildWebhookTab(),
          _buildServicesTab(),
          _buildDataSyncTab(),
        ],
      ),
    );
  }

  Widget _buildAPITab() {
    return Column(
      children: [
        if (_apiTestResult.isNotEmpty)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Text(_apiTestResult, style: const TextStyle(color: Colors.green)),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _apis.length,
            itemBuilder: (ctx, i) {
              final api = _apis[i];
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
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.api, color: Colors.deepPurple),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(api.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text(api.description, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: api.status == 'Connected' ? Colors.green.withOpacity(0.2) : 
                                   api.status == 'Pending' ? Colors.orange.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(api.status, style: TextStyle(color: api.status == 'Connected' ? Colors.green : Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Endpoint: ${api.endpoint}', style: const TextStyle(color: Colors.white70)),
                    if (api.apiKey.isNotEmpty)
                      Text('API Key: ${api.apiKey}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (api.status != 'Connected')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _connectAPI(api),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text('CONNECT'),
                            ),
                          ),
                        if (api.status == 'Connected')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _disconnectAPI(api),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('DISCONNECT'),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isTestingAPI ? null : () => _testAPI(api),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: _isTestingAPI ? const CircularProgressIndicator() : const Text('TEST'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWebhookTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TextField(
                controller: _webhookNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Webhook Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _webhookUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Webhook URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addWebhook,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('ADD WEBHOOK'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _webhooks.length,
            itemBuilder: (ctx, i) {
              final webhook = _webhooks[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.webhook, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(webhook.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(webhook.url, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('Last: ${_formatTime(webhook.lastTrigger)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                    Switch(
                      value: webhook.status == 'Active',
                      onChanged: (_) => _toggleWebhook(webhook),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteWebhook(webhook),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServicesTab() {
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (ctx, i) {
        final service = _services[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(service.icon, color: service.color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(service.description, style: const TextStyle(color: Colors.grey)),
                    Text('Status: ${service.status}', style: TextStyle(color: service.status == 'Connected' ? Colors.green : Colors.red)),
                  ],
                ),
              ),
              if (service.status != 'Connected')
                ElevatedButton(
                  onPressed: () => _connectService(service),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('CONNECT'),
                ),
              if (service.status == 'Connected')
                OutlinedButton(
                  onPressed: () => _disconnectService(service),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('DISCONNECT'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataSyncTab() {
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
                const Icon(Icons.sync, size: 48, color: Colors.cyan),
                const SizedBox(height: 12),
                Text('Last Sync: ${_formatDateTime(_lastSync)}', style: const TextStyle(color: Colors.white)),
                Text('Records Synced: $_syncedRecords', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                if (_isSyncing)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _syncData,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                    child: const Text('SYNC NOW'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sync History', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._syncLogs.map((log) => ListTile(
                  leading: Icon(
                    log.status == 'SUCCESS' ? Icons.check_circle : Icons.warning,
                    color: log.status == 'SUCCESS' ? Colors.green : Colors.orange,
                  ),
                  title: Text(log.message, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${_formatDateTime(log.time)} • ${log.records} records', style: const TextStyle(color: Colors.grey)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  String _formatDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class APIIntegration {
  final String name;
  final String description;
  String status;
  final String endpoint;
  String apiKey;

  APIIntegration(this.name, this.description, this.status, this.endpoint, this.apiKey);
}

class Webhook {
  final String name;
  final String url;
  String status;
  final DateTime lastTrigger;

  Webhook(this.name, this.url, this.status, this.lastTrigger);
}

class ExternalService {
  final String name;
  final String description;
  String status;
  final IconData icon;
  final Color color;

  ExternalService(this.name, this.description, this.status, this.icon, this.color);
}

class SyncLog {
  final DateTime time;
  final String status;
  final String message;
  final int records;

  SyncLog(this.time, this.status, this.message, this.records);
}
