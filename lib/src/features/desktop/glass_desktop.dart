import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../core/theme/theme_engine.dart';
import '../../widgets/zion_widgets.dart';
import '../settings/zion_settings.dart';
import '../wifi/zion_wifi_panel.dart';
import '../../../cosmic_terminal.dart';

class GlassDesktop extends StatefulWidget {
  const GlassDesktop({super.key});

  @override
  State<GlassDesktop> createState() => _GlassDesktopState();
}

class _GlassDesktopState extends State<GlassDesktop> with TickerProviderStateMixin {
  final ThemeEngine _theme = ThemeEngine();
  final List<GlassWindow> _windows = [];
  int _nextWindowId = 1;
  DateTime _currentTime = DateTime.now();
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _menuController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _menuAnimation = CurvedAnimation(parent: _menuController, curve: Curves.easeOutBack);
  }

  void _updateTime() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _currentTime = DateTime.now());
        _updateTime();
      }
    });
  }

  void _openWindow(String title, Widget content, {Size size = const Size(900, 700)}) {
    setState(() {
      _windows.add(GlassWindow(
        id: _nextWindowId++,
        title: title,
        content: content,
        position: Offset(50 + _windows.length * 30, 50 + _windows.length * 30),
        size: size,
      ));
    });
  }

  void _closeWindow(int id) {
    setState(() => _windows.removeWhere((w) => w.id == id));
  }

  void _bringToFront(int id) {
    final index = _windows.indexWhere((w) => w.id == id);
    if (index != -1 && index != _windows.length - 1) {
      setState(() {
        final window = _windows.removeAt(index);
        _windows.add(window);
      });
    }
  }

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
    if (_menuOpen) {
      _menuController.forward();
    } else {
      _menuController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: _theme.getGradientBackground()),
        child: Stack(
          children: [
            _buildMatrixRain(),
            _buildDock(),
            ..._windows.map((w) => _buildGlassWindow(w)),
            _buildStartMenu(),
            _buildTaskbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixRain() {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
      ).createShader(rect),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _theme.currentTheme.accent.withValues(alpha: 0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: const Center(
          child: ZionGradientText(
            text: 'ZION OS\nv3.0',
            fontSize: 64,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassWindow(GlassWindow w) {
    return Positioned(
      left: w.position.dx,
      top: w.position.dy,
      child: GestureDetector(
        onTap: () => _bringToFront(w.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: w.size.width,
          height: w.size.height,
          decoration: BoxDecoration(
            color: _theme.currentTheme.background.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _theme.currentTheme.accent.withValues(alpha: 0.3), width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
              BoxShadow(color: _theme.currentTheme.accent.withValues(alpha: 0.1), blurRadius: 30, spreadRadius: 5),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Column(
                children: [
                  _buildWindowTitleBar(w),
                  Expanded(child: w.content),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWindowTitleBar(GlassWindow w) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _theme.currentTheme.accent.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        border: Border(bottom: BorderSide(color: _theme.currentTheme.accent.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Row(
            children: [
              _buildWindowButton(Colors.red, () => _closeWindow(w.id)),
              const SizedBox(width: 8),
              _buildWindowButton(Colors.amber, () {}),
              const SizedBox(width: 8),
              _buildWindowButton(Colors.green, () {}),
            ],
          ),
          const SizedBox(width: 16),
          Text(w.title, style: TextStyle(color: _theme.currentTheme.accent, fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          ZionIcon(icon: Icons.refresh, size: 16, onTap: () {}),
          const SizedBox(width: 8),
          ZionIcon(icon: Icons.fullscreen, size: 16, onTap: () {}),
          const SizedBox(width: 8),
          ZionIcon(icon: Icons.close, size: 16, onTap: () => _closeWindow(w.id)),
        ],
      ),
    );
  }

  Widget _buildWindowButton(Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4)],
        ),
      ),
    );
  }

  Widget _buildDock() {
    final icons = [
      {'icon': Icons.terminal, 'label': 'Terminal', 'widget': const CosmicTerminal()},
      {'icon': Icons.wifi, 'label': 'WiFi', 'widget': const ZionWifiPanel()},
      {'icon': Icons.psychology, 'label': 'SI Agent', 'widget': const Center(child: Text('SI Agent'))},
      {'icon': Icons.settings, 'label': 'Settings', 'widget': const ZionSettings()},
    ];

    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _theme.currentTheme.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _theme.currentTheme.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: icons.map((icon) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: () => _openWindow(icon['label'] as String, icon['widget'] as Widget),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ZionIcon(icon: icon['icon'] as IconData, size: 28),
                        const SizedBox(height: 4),
                        Text(icon['label'] as String, style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartMenu() {
    if (!_menuOpen) return const SizedBox.shrink();
    
    return Positioned(
      bottom: 70,
      left: 16,
      child: ScaleTransition(
        scale: _menuAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: _theme.currentTheme.background.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _theme.currentTheme.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _theme.currentTheme.accent.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 30, backgroundColor: Colors.green, child: Icon(Icons.person, color: Colors.white, size: 30)),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Zion User', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('zion@os', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  _buildMenuItem(Icons.terminal, 'Terminal', () => _openWindow('Terminal', const CosmicTerminal())),
                  _buildMenuItem(Icons.wifi, 'WiFi Panel', () => _openWindow('WiFi', const ZionWifiPanel())),
                  _buildMenuItem(Icons.psychology, 'SI Agent', () => _openWindow('SI Agent', const Center(child: Text('SI Agent')))),
                  _buildMenuItem(Icons.settings, 'Settings', () => _openWindow('Settings', const ZionSettings())),
                  const Divider(color: Colors.white24),
                  _buildMenuItem(Icons.exit_to_app, 'Lock Screen', () {}),
                  _buildMenuItem(Icons.power_settings_new, 'Shutdown', () => Navigator.pop(context), color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: ZionIcon(icon: icon, size: 20),
      title: Text(title, style: TextStyle(color: color ?? Colors.white)),
      onTap: () {
        _toggleMenu();
        onTap();
      },
    );
  }

  Widget _buildTaskbar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: _theme.currentTheme.background.withValues(alpha: 0.85),
          border: Border(top: BorderSide(color: _theme.currentTheme.accent.withValues(alpha: 0.3))),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                width: 70,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [_theme.currentTheme.accent, _theme.currentTheme.accent.withValues(alpha: 0.7)]),
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 30),
              ),
            ),
            Expanded(child: Container()),
            _buildSystemTray(),
            _buildClock(),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemTray() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ZionIcon(icon: Icons.battery_full, size: 18),
          const SizedBox(width: 12),
          ZionIcon(icon: Icons.wifi, size: 18),
          const SizedBox(width: 12),
          ZionIcon(icon: Icons.volume_up, size: 18),
        ],
      ),
    );
  }

  Widget _buildClock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_formatTime(_currentTime), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          Text(_formatDate(_currentTime), style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  String _formatDate(DateTime time) => '${time.day}/${time.month}/${time.year}';
}

class GlassWindow {
  final int id;
  final String title;
  final Widget content;
  Offset position;
  final Size size;
  GlassWindow({required this.id, required this.title, required this.content, required this.position, required this.size});
}
