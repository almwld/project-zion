import 'dart:ui';
import 'package:flutter/material.dart';
import 'apps/terminal_app.dart';
import 'apps/network_scanner.dart';
import 'apps/wifi_scanner.dart';
import 'apps/exploit_db.dart';
import 'apps/crypto_tool.dart';
import 'apps/stealth_mode.dart';
import 'apps/password_cracker.dart';
import 'apps/ddos_attack.dart';
import 'apps/forensics.dart';
import 'apps/database_hacking.dart';
import 'apps/cloud_attacks.dart';

void main() {
  runApp(const ZionOSApp());
}

class ZionOSApp extends StatelessWidget {
  const ZionOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZION OS 2027',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const ZionDesktop(),
    );
  }
}

class ZionDesktop extends StatelessWidget {
  const ZionDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية متدرجة - سوداء مع لمسات تركوازية
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF0D2E3B), // تركواز داكن
                  Color(0xFF061217), // أسود مائل للتركواز
                  Color(0xFF03090C),
                ],
              ),
            ),
          ),
          Column(
            children: [
              const ZionTopBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const ZionSearchBar(),
                      const SizedBox(height: 25),
                      const WorkspacesPreview(),
                      const SizedBox(height: 35),
                      const Expanded(child: ZionAppGrid()),
                      const PageIndicator(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const ZionDock(),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// الشريط العلوي - Top Bar (تركواز)
// ============================================
class ZionTopBar extends StatelessWidget {
  const ZionTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      color: Colors.black.withOpacity(0.85),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ZION OS 2027', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF00BCD4))),
          Text('SECURE MODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xFF00BCD4))),
          Row(
            children: [
              Icon(Icons.network_wifi, size: 14, color: Color(0xFF00BCD4)),
              SizedBox(width: 12),
              Icon(Icons.battery_full, size: 14, color: Color(0xFF00BCD4)),
              SizedBox(width: 12),
              Icon(Icons.security, size: 14, color: Color(0xFF00BCD4)),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// شريط البحث - Search Bar (تركواز)
// ============================================
class ZionSearchBar extends StatelessWidget {
  const ZionSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 40,
      child: TextField(
        style: const TextStyle(fontSize: 14, color: Color(0xFF00BCD4)),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF00BCD4)),
          hintText: 'Type to search...',
          hintStyle: const TextStyle(color: Color(0xFF00BCD4), fontSize: 13),
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ============================================
// معاينة أسطح المكتب - Workspaces Preview
// ============================================
class WorkspacesPreview extends StatelessWidget {
  const WorkspacesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWorkspaceCard(isActive: true),
        const SizedBox(width: 20),
        _buildWorkspaceCard(isActive: false),
      ],
    );
  }

  Widget _buildWorkspaceCard({required bool isActive}) {
    return Container(
      width: 170,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1A2A2F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? const Color(0xFF00BCD4).withOpacity(0.6) : Colors.white.withOpacity(0.05),
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF00BCD4).withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Center(
        child: Icon(
          Icons.grid_view,
          size: 20,
          color: isActive ? const Color(0xFF00BCD4).withOpacity(0.6) : Colors.white.withOpacity(0.15),
        ),
      ),
    );
  }
}

// ============================================
// شبكة التطبيقات - App Grid (تركواز)
// ============================================
class ZionAppGrid extends StatelessWidget {
  const ZionAppGrid({super.key});

  static const List<Map<String, dynamic>> apps = [
    {'name': 'TERMINAL', 'icon': Icons.terminal, 'gradient': [Color(0xFF00838F), Color(0xFF004D40)]},
    {'name': 'NETWORK', 'icon': Icons.network_wifi, 'gradient': [Color(0xFF00ACC1), Color(0xFF006064)]},
    {'name': 'WIFI', 'icon': Icons.wifi, 'gradient': [Color(0xFF26C6DA), Color(0xFF00838F)]},
    {'name': 'EXPLOIT', 'icon': Icons.bug_report, 'gradient': [Color(0xFF00838F), Color(0xFF00363A)]},
    {'name': 'CRYPTO', 'icon': Icons.lock, 'gradient': [Color(0xFF00BCD4), Color(0xFF006064)]},
    {'name': 'STEALTH', 'icon': Icons.visibility_off, 'gradient': [Color(0xFF004D40), Color(0xFF001F1A)]},
    {'name': 'CRACKER', 'icon': Icons.vpn_key, 'gradient': [Color(0xFF00ACC1), Color(0xFF004D40)]},
    {'name': 'DDOS', 'icon': Icons.speed, 'gradient': [Color(0xFF26C6DA), Color(0xFF006064)]},
    {'name': 'FORENSICS', 'icon': Icons.search, 'gradient': [Color(0xFF00838F), Color(0xFF001F1A)]},
    {'name': 'DATABASE', 'icon': Icons.storage, 'gradient': [Color(0xFF00BCD4), Color(0xFF00363A)]},
    {'name': 'CLOUD', 'icon': Icons.cloud, 'gradient': [Color(0xFF00ACC1), Color(0xFF004D40)]},
    {'name': 'SETTINGS', 'icon': Icons.settings, 'gradient': [Color(0xFF006064), Color(0xFF001F1A)]},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        childAspectRatio: 0.9,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: apps[index]['gradient'],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BCD4).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Icon(apps[index]['icon'], color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              apps[index]['name'],
              style: const TextStyle(fontSize: 11, color: Color(0xFFB2EBF2), letterSpacing: 0.5),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

// ============================================
// مؤشر الصفحات - Page Indicator
// ============================================
class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(color: Color(0xFF00BCD4), shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: const Color(0xFF00BCD4).withOpacity(0.25), shape: BoxShape.circle),
        ),
      ],
    );
  }
}

// ============================================
// الشريط السفلي - The Dock (زجاجي - تركواز)
// ============================================
class ZionDock extends StatelessWidget {
  const ZionDock({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dockApps = [
      {'name': 'TERM', 'icon': Icons.terminal},
      {'name': 'NET', 'icon': Icons.network_wifi},
      {'name': 'WIFI', 'icon': Icons.wifi},
      {'name': 'LOCK', 'icon': Icons.lock},
      {'name': 'HIDE', 'icon': Icons.visibility_off},
      {'name': 'KEY', 'icon': Icons.vpn_key},
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00BCD4).withOpacity(0.15), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...dockApps.map((app) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF00BCD4), Color(0xFF006064)],
                        ),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(app['icon'], color: Colors.white, size: 24),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                width: 1,
                color: const Color(0xFF00BCD4).withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.apps, color: Color(0xFF00BCD4), size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
