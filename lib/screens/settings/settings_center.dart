import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCenter extends StatefulWidget {
  const SettingsCenter({super.key});

  @override
  State<SettingsCenter> createState() => _SettingsCenterState();
}

class _SettingsCenterState extends State<SettingsCenter> {
  bool _darkMode = true;
  bool _notifications = true;
  bool _autoUpdate = true;
  bool _stealthMode = false;
  String _selectedTheme = 'Turquoise';
  String _selectedLanguage = 'العربية';
  double _animationSpeed = 1.0;
  int _selectedFontSize = 14;

  final List<String> _themes = ['Turquoise', 'Cyber Green', 'Neon Blue', 'Dark Purple'];
  final List<String> _languages = ['العربية', 'English', 'Français', 'Español'];
  final List<int> _fontSizes = [12, 14, 16, 18, 20];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? true;
      _notifications = prefs.getBool('notifications') ?? true;
      _autoUpdate = prefs.getBool('auto_update') ?? true;
      _stealthMode = prefs.getBool('stealth_mode') ?? false;
      _selectedTheme = prefs.getString('theme') ?? 'Turquoise';
      _selectedLanguage = prefs.getString('language') ?? 'العربية';
      _animationSpeed = prefs.getDouble('animation_speed') ?? 1.0;
      _selectedFontSize = prefs.getInt('font_size') ?? 14;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is String) await prefs.setString(key, value);
    if (value is double) await prefs.setDouble(key, value);
    if (value is int) await prefs.setInt(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Color(0xFF00BCD4))),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00BCD4)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(Icons.palette, 'Appearance'),
          _buildThemeSelector(),
          _buildLanguageSelector(),
          _buildFontSizeSelector(),
          
          // Behavior Section
          _buildSectionHeader(Icons.tune, 'Behavior'),
          _buildSwitchTile(Icons.dark_mode, 'Dark Mode', _darkMode, (v) {
            setState(() { _darkMode = v; _saveSetting('dark_mode', v); });
          }),
          _buildSwitchTile(Icons.notifications, 'Notifications', _notifications, (v) {
            setState(() { _notifications = v; _saveSetting('notifications', v); });
          }),
          _buildSwitchTile(Icons.update, 'Auto Update', _autoUpdate, (v) {
            setState(() { _autoUpdate = v; _saveSetting('auto_update', v); });
          }),
          _buildSwitchTile(Icons.visibility_off, 'Stealth Mode', _stealthMode, (v) {
            setState(() { _stealthMode = v; _saveSetting('stealth_mode', v); });
          }),
          
          // Performance Section
          _buildSectionHeader(Icons.speed, 'Performance'),
          _buildSliderTile('Animation Speed', _animationSpeed, 0.5, 2.0, (v) {
            setState(() { _animationSpeed = v; _saveSetting('animation_speed', v); });
          }),
          
          // Security Section
          _buildSectionHeader(Icons.security, 'Security'),
          _buildInfoTile(Icons.fingerprint, 'Change PIN', '••••', () {
            _showChangePinDialog();
          }),
          _buildInfoTile(Icons.biometric, 'Biometric Authentication', 'Disabled', () {}),
          _buildInfoTile(Icons.encryption, 'Encryption Status', 'Active (AES-256)', () {}),
          
          // About Section
          _buildSectionHeader(Icons.info, 'About'),
          _buildInfoTile(Icons.version, 'Version', 'Zion OS 2027 v4.0.0', () {}),
          _buildInfoTile(Icons.build, 'Build Number', '2027.04.15', () {}),
          _buildInfoTile(Icons.code, 'Developer', 'Zion Security Team', () {}),
          
          const SizedBox(height: 30),
          
          // Reset Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: _resetSettings,
              icon: const Icon(Icons.restore),
              label: const Text('Reset to Default'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00BCD4), size: 20),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00BCD4),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF00BCD4), size: 20),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00BCD4),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF00BCD4), size: 20),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
            Row(
              children: [
                Text(value, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.color_lens, color: Color(0xFF00BCD4), size: 20),
              const SizedBox(width: 12),
              const Text('Theme', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          DropdownButton<String>(
            value: _selectedTheme,
            dropdownColor: Colors.black,
            underline: const SizedBox(),
            style: const TextStyle(color: Color(0xFF00BCD4)),
            items: _themes.map((theme) {
              return DropdownMenuItem(value: theme, child: Text(theme));
            }).toList(),
            onChanged: (v) {
              setState(() { _selectedTheme = v!; _saveSetting('theme', v); });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: Color(0xFF00BCD4), size: 20),
              const SizedBox(width: 12),
              const Text('Language', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            dropdownColor: Colors.black,
            underline: const SizedBox(),
            style: const TextStyle(color: Color(0xFF00BCD4)),
            items: _languages.map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (v) {
              setState(() { _selectedLanguage = v!; _saveSetting('language', v); });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.text_fields, color: Color(0xFF00BCD4), size: 20),
              const SizedBox(width: 12),
              const Text('Font Size', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          DropdownButton<int>(
            value: _selectedFontSize,
            dropdownColor: Colors.black,
            underline: const SizedBox(),
            style: const TextStyle(color: Color(0xFF00BCD4)),
            items: _fontSizes.map((size) {
              return DropdownMenuItem(value: size, child: Text('$size'));
            }).toList(),
            onChanged: (v) {
              setState(() { _selectedFontSize = v!; _saveSetting('font_size', v); });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(String title, double value, double min, double max, Function(double) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.animation, color: Color(0xFF00BCD4), size: 20),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              const Spacer(),
              Text('${value.toStringAsFixed(1)}x', style: const TextStyle(color: Color(0xFF00BCD4))),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: const Color(0xFF00BCD4),
            inactiveColor: Colors.white24,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePinDialog() async {
    final TextEditingController oldPinController = TextEditingController();
    final TextEditingController newPinController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN', style: TextStyle(color: Color(0xFF00BCD4))),
        backgroundColor: Colors.black,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPinController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Current PIN',
                labelStyle: TextStyle(color: Color(0xFF00BCD4)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPinController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'New PIN',
                labelStyle: TextStyle(color: Color(0xFF00BCD4)),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () async {
              if (oldPinController.text == '1234') {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('user_pin', newPinController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN changed successfully'), backgroundColor: Color(0xFF00BCD4)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wrong current PIN'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFF00BCD4))),
          ),
        ],
      ),
    );
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _loadSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset to default'), backgroundColor: Color(0xFF00BCD4)),
    );
  }
}
