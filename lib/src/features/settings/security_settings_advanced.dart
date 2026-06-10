import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class SecuritySettingsAdvanced extends StatefulWidget {
  const SecuritySettingsAdvanced({super.key});

  @override
  State<SecuritySettingsAdvanced> createState() => _SecuritySettingsAdvancedState();
}

class _SecuritySettingsAdvancedState extends State<SecuritySettingsAdvanced> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool _biometricEnabled = false;
  bool _lockScreenEnabled = true;
  int _autoLockMinutes = 5;
  bool _stealthMode = false;
  bool _encryptData = false;
  String _pinCode = '1234';
  bool _showPinOnScreen = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      _lockScreenEnabled = prefs.getBool('lock_screen_enabled') ?? true;
      _autoLockMinutes = prefs.getInt('auto_lock_minutes') ?? 5;
      _stealthMode = prefs.getBool('stealth_mode') ?? false;
      _encryptData = prefs.getBool('encrypt_data') ?? false;
      _pinCode = prefs.getString('pin_code') ?? '1234';
      _showPinOnScreen = prefs.getBool('show_pin_on_screen') ?? false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    else if (value is int) await prefs.setInt(key, value);
    else if (value is String) await prefs.setString(key, value);
    setState(() {
      if (key == 'biometric_enabled') _biometricEnabled = value;
      else if (key == 'lock_screen_enabled') _lockScreenEnabled = value;
      else if (key == 'auto_lock_minutes') _autoLockMinutes = value;
      else if (key == 'stealth_mode') _stealthMode = value;
      else if (key == 'encrypt_data') _encryptData = value;
      else if (key == 'pin_code') _pinCode = value;
      else if (key == 'show_pin_on_screen') _showPinOnScreen = value;
    });
  }

  Future<void> _changePinCode() async {
    final controller = TextEditingController(text: _pinCode);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change PIN Code'),
        content: TextField(
          controller: controller,
          obscureText: !_showPinOnScreen,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter new PIN',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _saveSetting('pin_code', controller.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN code changed')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Security Settings'),
        backgroundColor: Colors.red.shade900,
      ),
      body: ListView(
        children: [
          _buildSwitchSetting('Lock Screen', _lockScreenEnabled, 'lock_screen_enabled'),
          _buildSwitchSetting('Biometric Authentication', _biometricEnabled, 'biometric_enabled'),
          _buildSliderSetting('Auto Lock (minutes)', _autoLockMinutes, 1, 30, 1, 'auto_lock_minutes'),
          _buildSwitchSetting('Stealth Mode', _stealthMode, 'stealth_mode'),
          _buildSwitchSetting('Data Encryption', _encryptData, 'encrypt_data'),
          ListTile(
            leading: const Icon(Icons.pin, color: Colors.red),
            title: const Text('Change PIN Code', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: _changePinCode,
          ),
          _buildSwitchSetting('Show PIN on Screen', _showPinOnScreen, 'show_pin_on_screen'),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text('Clear All Security Data', style: TextStyle(color: Colors.white)),
            onTap: () => _clearSecurityData(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(String label, int value, int min, int max, int step, String key) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      subtitle: Slider(
        value: value.toDouble(),
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: (max - min) ~/ step,
        activeColor: Colors.red,
        onChanged: (v) => _saveSetting(key, v.toInt()),
      ),
      trailing: Text('$value min', style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildSwitchSetting(String label, bool value, String key) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: (v) => _saveSetting(key, v),
      activeColor: Colors.red,
    );
  }

  void _clearSecurityData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Security Data'),
        content: const Text('Are you sure? This will reset all security settings.'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    
    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('biometric_enabled');
      await prefs.remove('lock_screen_enabled');
      await prefs.remove('auto_lock_minutes');
      await prefs.remove('stealth_mode');
      await prefs.remove('encrypt_data');
      await prefs.remove('pin_code');
      _loadSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Security data cleared')),
      );
    }
  }
}
