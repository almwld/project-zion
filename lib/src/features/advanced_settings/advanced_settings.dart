import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvancedSettings extends StatefulWidget {
  const AdvancedSettings({super.key});

  @override
  State<AdvancedSettings> createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettings> {
  bool _darkMode = true;
  bool _animations = true;
  double _animationSpeed = 1.0;
  String _accentColor = 'green';
  int _fontSize = 14;

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
      _fontSize = prefs.getInt('font_size') ?? 14;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Advanced Settings'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (v) => _saveSetting('dark_mode', v),
          ),
          SwitchListTile(
            title: const Text('Animations'),
            value: _animations,
            onChanged: (v) => _saveSetting('animations', v),
          ),
          ListTile(
            title: const Text('Animation Speed'),
            subtitle: Slider(
              value: _animationSpeed,
              min: 0.5,
              max: 2.0,
              onChanged: (v) => _saveSetting('animation_speed', v),
            ),
            trailing: Text('${_animationSpeed.toStringAsFixed(1)}x'),
          ),
          ListTile(
            title: const Text('Accent Color'),
            trailing: DropdownButton<String>(
              value: _accentColor,
              items: ['green', 'blue', 'red', 'purple'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => _saveSetting('accent_color', v),
            ),
          ),
          ListTile(
            title: const Text('Font Size'),
            trailing: DropdownButton<int>(
              value: _fontSize,
              items: [12, 14, 16, 18].map((s) => DropdownMenuItem(value: s, child: Text('$s'))).toList(),
              onChanged: (v) => _saveSetting('font_size', v),
            ),
          ),
        ],
      ),
    );
  }
}
