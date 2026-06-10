import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class DeveloperCenter extends StatefulWidget {
  const DeveloperCenter({super.key});

  @override
  State<DeveloperCenter> createState() => _DeveloperCenterState();
}

class _DeveloperCenterState extends State<DeveloperCenter> {
  int _selectedTab = 0;
  
  // API Testing
  final TextEditingController _apiUrlController = TextEditingController();
  final TextEditingController _apiBodyController = TextEditingController();
  String _apiResponse = '';
  bool _isApiLoading = false;
  String _selectedMethod = 'GET';
  
  // Code Snippets
  List<CodeSnippet> _snippets = [];
  final TextEditingController _codeController = TextEditingController();
  String _selectedLanguage = 'Dart';
  
  // Log Viewer
  List<LogEntry> _logs = [];
  final TextEditingController _logFilterController = TextEditingController();
  
  // Environment
  Map<String, String> _envVars = {};
  final TextEditingController _envKeyController = TextEditingController();
  final TextEditingController _envValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSnippets();
    _loadLogs();
    _loadEnvVars();
  }

  void _loadSnippets() {
    _snippets = [
      CodeSnippet(
        id: '1',
        title: 'HTTP GET Request',
        language: 'Dart',
        code: '''
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('https://api.example.com/data'));
  if (response.statusCode == 200) {
    print(response.body);
  }
}''',
      ),
      CodeSnippet(
        id: '2',
        title: 'JSON Parsing',
        language: 'Dart',
        code: '''
import 'dart:convert';

void parseJson(String jsonString) {
  final data = jsonDecode(jsonString);
  print(data['key']);
}''',
      ),
      CodeSnippet(
        id: '3',
        title: 'File Operations',
        language: 'Dart',
        code: '''
import 'dart:io';

Future<void> readFile(String path) async {
  final file = File(path);
  final contents = await file.readAsString();
  print(contents);
}''',
      ),
    ];
  }

  void _loadLogs() {
    _logs = [
      LogEntry('App started', DateTime.now().subtract(const Duration(minutes: 30)), 'INFO'),
      LogEntry('User logged in', DateTime.now().subtract(const Duration(minutes: 25)), 'INFO'),
      LogEntry('Network scan completed', DateTime.now().subtract(const Duration(minutes: 15)), 'SUCCESS'),
      LogEntry('Warning: High memory usage', DateTime.now().subtract(const Duration(minutes: 5)), 'WARNING'),
    ];
  }

  void _loadEnvVars() {
    _envVars = {
      'API_KEY': 'your-api-key-here',
      'DEBUG_MODE': 'true',
      'ZION_VERSION': '3.3.0',
    };
  }

  Future<void> _executeApiRequest() async {
    if (_apiUrlController.text.isEmpty) return;
    
    setState(() {
      _isApiLoading = true;
      _apiResponse = 'Loading...';
    });

    try {
      final url = Uri.parse(_apiUrlController.text);
      http.Response response;
      
      switch (_selectedMethod) {
        case 'GET':
          response = await http.get(url);
          break;
        case 'POST':
          response = await http.post(
            url,
            body: _apiBodyController.text.isNotEmpty ? jsonDecode(_apiBodyController.text) : null,
          );
          break;
        default:
          response = await http.get(url);
      }
      
      setState(() {
        _apiResponse = 'Status: ${response.statusCode}\n\nBody:\n${response.body}';
        _isApiLoading = false;
      });
    } catch (e) {
      setState(() {
        _apiResponse = 'Error: $e';
        _isApiLoading = false;
      });
    }
  }

  void _addSnippet() {
    if (_codeController.text.isEmpty) return;
    
    final newSnippet = CodeSnippet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Custom Snippet ${_snippets.length + 1}',
      language: _selectedLanguage,
      code: _codeController.text,
    );
    
    setState(() {
      _snippets.insert(0, newSnippet);
      _codeController.clear();
    });
  }

  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _addEnvVar() {
    if (_envKeyController.text.isEmpty) return;
    
    setState(() {
      _envVars[_envKeyController.text] = _envValueController.text;
      _envKeyController.clear();
      _envValueController.clear();
    });
  }

  List<LogEntry> get _filteredLogs {
    if (_logFilterController.text.isEmpty) return _logs;
    return _logs.where((l) => 
      l.message.toLowerCase().contains(_logFilterController.text.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Developer Center'),
        backgroundColor: Colors.deepPurple.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.api), text: 'API Tester'),
            Tab(icon: Icon(Icons.code), text: 'Code Snippets'),
            Tab(icon: Icon(Icons.list_alt), text: 'Log Viewer'),
            Tab(icon: Icon(Icons.settings), text: 'Environment'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildApiTester(),
          _buildCodeSnippets(),
          _buildLogViewer(),
          _buildEnvironment(),
        ],
      ),
    );
  }

  Widget _buildApiTester() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedMethod,
            items: ['GET', 'POST', 'PUT', 'DELETE'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
            onChanged: (v) => setState(() => _selectedMethod = v!),
            decoration: const InputDecoration(
              labelText: 'Method',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _apiUrlController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'URL',
              border: OutlineInputBorder(),
              hintText: 'https://api.example.com/endpoint',
            ),
          ),
          if (_selectedMethod == 'POST')
            Column(
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: _apiBodyController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Request Body (JSON)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isApiLoading ? null : _executeApiRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: _isApiLoading ? const CircularProgressIndicator() : const Text('SEND REQUEST'),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Response', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  child: SelectableText(
                    _apiResponse,
                    style: const TextStyle(color: Colors.green, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippets() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Write your code here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              DropdownButton<String>(
                value: _selectedLanguage,
                items: ['Dart', 'Python', 'JavaScript', 'Bash'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setState(() => _selectedLanguage = v!),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _addSnippet,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Save Snippet'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _snippets.length,
            itemBuilder: (ctx, i) {
              final snippet = _snippets[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ExpansionTile(
                  leading: const Icon(Icons.code, color: Colors.deepPurple),
                  title: Text(snippet.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(snippet.language, style: const TextStyle(color: Colors.grey)),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        snippet.code,
                        style: const TextStyle(color: Colors.green, fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogViewer() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: TextField(
            controller: _logFilterController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Filter logs...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredLogs.length,
            itemBuilder: (ctx, i) {
              final log = _filteredLogs[i];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: log.type == 'ERROR' ? Colors.red :
                               log.type == 'WARNING' ? Colors.orange :
                               log.type == 'SUCCESS' ? Colors.green : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '[${log.time.hour}:${log.time.minute}:${log.time.second}] ${log.message}',
                            style: TextStyle(
                              color: log.type == 'ERROR' ? Colors.red :
                                     log.type == 'WARNING' ? Colors.orange :
                                     log.type == 'SUCCESS' ? Colors.green : Colors.white,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildEnvironment() {
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _envKeyController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _envValueController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Value',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.deepPurple),
                    onPressed: _addEnvVar,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._envVars.entries.map((entry) => Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(entry.key, style: const TextStyle(color: Colors.cyan, fontFamily: 'monospace')),
                    ),
                    Expanded(
                      child: Text(entry.value, style: const TextStyle(color: Colors.white70)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => setState(() => _envVars.remove(entry.key)),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class CodeSnippet {
  final String id;
  final String title;
  final String language;
  final String code;

  CodeSnippet({
    required this.id,
    required this.title,
    required this.language,
    required this.code,
  });
}

class LogEntry {
  final String message;
  final DateTime time;
  final String type;

  LogEntry(this.message, this.time, this.type);
}
