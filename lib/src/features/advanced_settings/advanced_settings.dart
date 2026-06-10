import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AdvancedSettings extends StatefulWidget {
  const AdvancedSettings({super.key});

  @override
  State<AdvancedSettings> createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettings> {
  // إعدادات المظهر
  bool _darkMode = true;
  bool _animations = true;
  double _animationSpeed = 1.0;
  String _accentColor = 'green';
  String _fontFamily = 'monospace';
  int _fontSize = 14;
  
  // إعدادات الخصوصية
  bool _stealthMode = false;
  bool _clearHistory = false;
  bool _disableAnalytics = true;
  bool _encryptData = false;
  
  // إعدادات الأداء
  int _maxProcesses = 50;
  bool _backgroundSync = true;
  bool _autoClean = false;
  int _cacheSize = 250;
  
  // إعدادات الشبكة
  bool _useProxy = false;
  String _proxyHost = '';
  int _proxyPort = 8080;
  int _timeout = 30;
  
  // إعدادات الإشعارات
  bool _enableNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  
  // إعدادات النظام
  bool _autoUpdate = true;
  bool _betaChannel = false;
  String _language = 'en';
  String _timezone = 'UTC';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? true;
      _animations = prefs.getBool('animations') ?? true;
      _animationSpeed = prefs.getDouble('animation_speed') ?? 1.0;
      _accentColor = prefs.getString('accent_color') ?? 'green';
      _fontFamily = prefs.getString('font_family') ?? 'monospace';
      _fontSize = prefs.getInt('font_size') ?? 14;
      _stealthMode = prefs.getBool('stealth_mode') ?? false;
      _clearHistory = prefs.getBool('clear_history') ?? false;
      _disableAnalytics = prefs.getBool('disable_analytics') ?? true;
      _encryptData = prefs.getBool('encrypt_data') ?? false;
      _maxProcesses = prefs.getInt('max_processes') ?? 50;
      _backgroundSync = prefs.getBool('background_sync') ?? true;
      _autoClean = prefs.getBool('auto_clean') ?? false;
      _cacheSize = prefs.getInt('cache_size') ?? 250;
      _useProxy = prefs.getBool('use_proxy') ?? false;
      _proxyHost = prefs.getString('proxy_host') ?? '';
      _proxyPort = prefs.getInt('proxy_port') ?? 8080;
      _timeout = prefs.getInt('timeout') ?? 30;
      _enableNotifications = prefs.getBool('enable_notifications') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? false;
      _autoUpdate = prefs.getBool('auto_update') ?? true;
      _betaChannel = prefs.getBool('beta_channel') ?? false;
      _language = prefs.getString('language') ?? 'en';
      _timezone = prefs.getString('timezone') ?? 'UTC';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    else if (value is double) await prefs.setDouble(key, value);
    else if (value is int) await prefs.setInt(key, value);
    else if (value is String) await prefs.setString(key, value);
    setState(() {});
  }

  void _exportSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final settings = <String, dynamic>{};
    for (final key in allKeys) {
      settings[key] = prefs.get(key);
    }
    
    final String? path = await FilePicker.platform.saveFile();
    if (path != null) {
      final file = File(path);
      await file.writeAsString(settings.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings exported successfully')),
      );
    }
  }

  void _importSettings() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      // قراءة وتطبيق الإعدادات
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings imported successfully')),
      );
    }
  }

  void _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default?'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Reset', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    
    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _loadSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings reset to default')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Advanced Settings'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: _exportSettings,
            tooltip: 'Export Settings',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _importSettings,
            tooltip: 'Import Settings',
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetSettings,
            tooltip: 'Reset Settings',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAppearanceSection()),
          SliverToBoxAdapter(child: _buildPrivacySection()),
          SliverToBoxAdapter(child: _buildPerformanceSection()),
          SliverToBoxAdapter(child: _buildNetworkSection()),
          SliverToBoxAdapter(child: _buildNotificationsSection()),
          SliverToBoxAdapter(child: _buildSystemSection()),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
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
          const Text('Appearance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: _darkMode,
            onChanged: (v) => _saveSetting('dark_mode', v),
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Animations'),
            subtitle: const Text('Enable UI animations'),
            value: _animations,
            onChanged: (v) => _saveSetting('animations', v),
            secondary: const Icon(Icons.animation),
          ),
          ListTile(
            title: const Text('Animation Speed'),
            subtitle: Slider(
              value: _animationSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              onChanged: (v) => _saveSetting('animation_speed', v),
            ),
            trailing: Text('${_animationSpeed.toStringAsFixed(1)}x'),
          ),
          ListTile(
            title: const Text('Accent Color'),
            subtitle: const Text('Choose primary color'),
            trailing: DropdownButton<String>(
              value: _accentColor,
              items: ['green', 'blue', 'red', 'purple', 'orange'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => _saveSetting('accent_color', v),
            ),
          ),
          ListTile(
            title: const Text('Font Family'),
            trailing: DropdownButton<String>(
              value: _fontFamily,
              items: ['monospace', 'roboto', 'courier', 'ubuntu'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (v) => _saveSetting('font_family', v),
            ),
          ),
          ListTile(
            title: const Text('Font Size'),
            trailing: DropdownButton<int>(
              value: _fontSize,
              items: [10, 11, 12, 13, 14, 15, 16, 18, 20].map((s) => DropdownMenuItem(value: s, child: Text('$s'))).toList(),
              onChanged: (v) => _saveSetting('font_size', v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
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
          const Text('Privacy & Security', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('Stealth Mode'),
            subtitle: const Text('Hide app activities and notifications'),
            value: _stealthMode,
            onChanged: (v) => _saveSetting('stealth_mode', v),
            secondary: const Icon(Icons.invisibility),
          ),
          SwitchListTile(
            title: const Text('Clear History'),
            subtitle: const Text('Auto-clear command history'),
            value: _clearHistory,
            onChanged: (v) => _saveSetting('clear_history', v),
            secondary: const Icon(Icons.delete_sweep),
          ),
          SwitchListTile(
            title: const Text('Disable Analytics'),
            subtitle: const Text('Opt out of anonymous usage data'),
            value: _disableAnalytics,
            onChanged: (v) => _saveSetting('disable_analytics', v),
            secondary: const Icon(Icons.analytics),
          ),
          SwitchListTile(
            title: const Text('Data Encryption'),
            subtitle: const Text('Encrypt stored data'),
            value: _encryptData,
            onChanged: (v) => _saveSetting('encrypt_data', v),
            secondary: const Icon(Icons.encryption),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
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
          const Text('Performance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ListTile(
            title: const Text('Max Background Processes'),
            subtitle: Slider(
              value: _maxProcesses.toDouble(),
              min: 10,
              max: 200,
              divisions: 19,
              onChanged: (v) => _saveSetting('max_processes', v.toInt()),
            ),
            trailing: Text('$_maxProcesses'),
          ),
          SwitchListTile(
            title: const Text('Background Sync'),
            subtitle: const Text('Sync data in background'),
            value: _backgroundSync,
            onChanged: (v) => _saveSetting('background_sync', v),
            secondary: const Icon(Icons.sync),
          ),
          SwitchListTile(
            title: const Text('Auto Clean Cache'),
            subtitle: const Text('Auto-clean cache weekly'),
            value: _autoClean,
            onChanged: (v) => _saveSetting('auto_clean', v),
            secondary: const Icon(Icons.cleaning_services),
          ),
          ListTile(
            title: const Text('Cache Size'),
            subtitle: Slider(
              value: _cacheSize.toDouble(),
              min: 50,
              max: 1000,
              divisions: 19,
              onChanged: (v) => _saveSetting('cache_size', v.toInt()),
            ),
            trailing: Text('$_cacheSize MB'),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkSection() {
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
          const Text('Network', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('Use Proxy'),
            subtitle: const Text('Route traffic through proxy'),
            value: _useProxy,
            onChanged: (v) => _saveSetting('use_proxy', v),
            secondary: const Icon(Icons.settings_ethernet),
          ),
          if (_useProxy) ...[
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Proxy Host',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => _saveSetting('proxy_host', v),
            ),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Proxy Port',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => _saveSetting('proxy_port', int.tryParse(v) ?? 8080),
            ),
          ],
          ListTile(
            title: const Text('Connection Timeout'),
            subtitle: Slider(
              value: _timeout.toDouble(),
              min: 10,
              max: 120,
              divisions: 11,
              onChanged: (v) => _saveSetting('timeout', v.toInt()),
            ),
            trailing: Text('$_timeout s'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
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
          const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _enableNotifications,
            onChanged: (v) => _saveSetting('enable_notifications', v),
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Sound'),
            value: _soundEnabled,
            onChanged: (v) => _saveSetting('sound_enabled', v),
            secondary: const Icon(Icons.volume_up),
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            value: _vibrationEnabled,
            onChanged: (v) => _saveSetting('vibration_enabled', v),
            secondary: const Icon(Icons.vibration),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSection() {
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
          const Text('System', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('Auto Update'),
            subtitle: const Text('Install updates automatically'),
            value: _autoUpdate,
            onChanged: (v) => _saveSetting('auto_update', v),
            secondary: const Icon(Icons.update),
          ),
          SwitchListTile(
            title: const Text('Beta Channel'),
            subtitle: const Text('Receive beta updates'),
            value: _betaChannel,
            onChanged: (v) => _saveSetting('beta_channel', v),
            secondary: const Icon(Icons.science),
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              items: ['en', 'ar', 'fr', 'es', 'de'].map((l) => DropdownMenuItem(value: l, child: Text(l.toUpperCase()))).toList(),
              onChanged: (v) => _saveSetting('language', v),
            ),
          ),
          ListTile(
            title: const Text('Timezone'),
            trailing: DropdownButton<String>(
              value: _timezone,
              items: ['UTC', 'EST', 'CST', 'MST', 'PST', 'GMT'].map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
              onChanged: (v) => _saveSetting('timezone', v),
            ),
          ),
        ],
      ),
    );
  }
}
