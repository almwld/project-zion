import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/responsive_helper.dart';

class DisplaySettings extends StatefulWidget {
  const DisplaySettings({super.key});

  @override
  State<DisplaySettings> createState() => _DisplaySettingsState();
}

class _DisplaySettingsState extends State<DisplaySettings> {
  double _scaleFactor = 1.0;
  double _iconSize = 48;
  double _windowOpacity = 0.95;
  bool _animations = true;
  String _taskbarPosition = 'bottom';
  bool _showClock = true;
  bool _showSystemTray = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _scaleFactor = prefs.getDouble('display_scale') ?? 1.0;
      _iconSize = prefs.getDouble('icon_size') ?? 48;
      _windowOpacity = prefs.getDouble('window_opacity') ?? 0.95;
      _animations = prefs.getBool('animations') ?? true;
      _taskbarPosition = prefs.getString('taskbar_position') ?? 'bottom';
      _showClock = prefs.getBool('show_clock') ?? true;
      _showSystemTray = prefs.getBool('show_system_tray') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is double) await prefs.setDouble(key, value);
    else if (value is bool) await prefs.setBool(key, value);
    else if (value is String) await prefs.setString(key, value);
    setState(() {
      if (key == 'display_scale') _scaleFactor = value;
      else if (key == 'icon_size') _iconSize = value;
      else if (key == 'window_opacity') _windowOpacity = value;
      else if (key == 'animations') _animations = value;
      else if (key == 'taskbar_position') _taskbarPosition = value;
      else if (key == 'show_clock') _showClock = value;
      else if (key == 'show_system_tray') _showSystemTray = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Display Settings'),
        backgroundColor: Colors.cyan.shade900,
      ),
      body: ListView(
        children: [
          _buildSliderSetting('Display Scale', _scaleFactor, 0.5, 1.5, 0.05, 'display_scale'),
          _buildSliderSetting('Icon Size (px)', _iconSize, 32, 80, 2, 'icon_size'),
          _buildSliderSetting('Window Opacity', _windowOpacity, 0.5, 1.0, 0.05, 'window_opacity'),
          _buildSwitchSetting('Enable Animations', _animations, 'animations'),
          _buildDropdownSetting('Taskbar Position', _taskbarPosition, ['bottom', 'top', 'left', 'right'], 'taskbar_position'),
          _buildSwitchSetting('Show Clock', _showClock, 'show_clock'),
          _buildSwitchSetting('Show System Tray', _showSystemTray, 'show_system_tray'),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.orange),
            title: const Text('Reset to Default', style: TextStyle(color: Colors.white)),
            onTap: () => _resetSettings(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(String label, double value, double min, double max, double step, String key) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      subtitle: Slider(
        value: value,
        min: min,
        max: max,
        divisions: ((max - min) / step).toInt(),
        activeColor: Colors.cyan,
        onChanged: (v) => _saveSetting(key, v),
      ),
      trailing: Text(value.toStringAsFixed(2), style: const TextStyle(color: Colors.cyan)),
    );
  }

  Widget _buildSwitchSetting(String label, bool value, String key) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: (v) => _saveSetting(key, v),
      activeColor: Colors.cyan,
    );
  }

  Widget _buildDropdownSetting(String label, String value, List<String> items, String key) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (v) => _saveSetting(key, v),
        dropdownColor: Colors.grey.shade900,
      ),
    );
  }

  void _resetSettings() async {
    await _saveSetting('display_scale', 1.0);
    await _saveSetting('icon_size', 48);
    await _saveSetting('window_opacity', 0.95);
    await _saveSetting('animations', true);
    await _saveSetting('taskbar_position', 'bottom');
    await _saveSetting('show_clock', true);
    await _saveSetting('show_system_tray', true);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Display settings reset to default')),
    );
  }
}
