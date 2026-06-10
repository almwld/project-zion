import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class DistroIntegration extends StatefulWidget {
  const DistroIntegration({super.key});

  @override
  State<DistroIntegration> createState() => _DistroIntegrationState();
}

class _DistroIntegrationState extends State<DistroIntegration> {
  int _selectedTab = 0;
  
  // Arch Linux (الأداء المطلق)
  List<ArchPackage> _archPackages = [];
  bool _archOptimized = false;
  
  // Manjora (الألعاب والإبداع)
  List<ManjoraFeature> _manjoraFeatures = [];
  bool _gamingMode = false;
  
  // CachyOS (تحسين الأداء)
  List<CachyOptimization> _cachyOptimizations = [];
  bool _performanceBoost = false;
  
  // Zorin (الواجهة الأنيقة)
  List<ZorinTheme> _zorinThemes = [];
  String _currentTheme = 'Zorin Blue';
  
  // Garda (الأمان)
  List<GardaSecurity> _gardaSecurity = [];
  bool _hardenedMode = false;
  
  // Pop!_OS (الإنتاجية)
  List<PopFeature> _popFeatures = [];
  bool _workspaceMode = false;
  
  // Fedora (التقنيات الحديثة)
  List<FedoraTech> _fedoraTech = [];
  bool _bleedingEdge = false;

  @override
  void initState() {
    super.initState();
    _loadArchPackages();
    _loadManjoraFeatures();
    _loadCachyOptimizations();
    _loadZorinThemes();
    _loadGardaSecurity();
    _loadPopFeatures();
    _loadFedoraTech();
  }

  void _loadArchPackages() {
    _archPackages = [
      ArchPackage('Arch Linux Base', 'Rolling release', 'Installed', Icons.architecture, Colors.cyan),
      ArchPackage('AUR Helper (yay)', 'Access to AUR packages', 'Installed', Icons.build, Colors.blue),
      ArchPackage('Kernel optimization', 'Custom kernel patches', 'Available', Icons.speed, Colors.green),
      ArchPackage('ZRAM配置', 'Improved memory management', 'Available', Icons.memory, Colors.orange),
    ];
    _archOptimized = true;
  }

  void _loadManjoraFeatures() {
    _manjoraFeatures = [
      ManjoraFeature('Gaming Mode', 'Optimized GPU scheduling', false, Icons.games, Colors.purple),
      ManjoraFeature('Hardware Detection', 'Automatic driver setup', true, Icons.computer, Colors.blue),
      ManjoraFeature('MSM (Manjaro Settings)', 'Easy configuration', true, Icons.settings, Colors.green),
      ManjoraFeature('Kernel Manager', 'Multiple kernel versions', true, Icons.code, Colors.orange),
    ];
  }

  void _loadCachyOptimizations() {
    _cachyOptimizations = [
      CachyOptimization('Bore Scheduler', 'Improved CPU scheduling', 85, Icons.speed, Colors.cyan),
      CachyOptimization('LTO (Link Time Optimization)', 'Better binary performance', 92, Icons.code, Colors.blue),
      CachyOptimization('PDS Scheduler', 'Low latency', 78, Icons.timer, Colors.green),
      CachyOptimization('CachyOS Kernel', 'Optimized kernel', 95, Icons.memory, Colors.orange),
    ];
  }

  void _loadZorinThemes() {
    _zorinThemes = [
      ZorinTheme('Zorin Blue', 'Default theme', Icons.palette, Colors.blue),
      ZorinTheme('Zorin Dark', 'Dark mode', Icons.dark_mode, Colors.grey),
      ZorinTheme('Zorin Light', 'Light theme', Icons.light_mode, Colors.white),
      ZorinTheme('MacOS Layout', 'Mac-style dock', Icons.apple, Colors.grey),
      ZorinTheme('Windows Layout', 'Windows-style menu', Icons.windows, Colors.blue),
    ];
    _currentTheme = 'Zorin Blue';
  }

  void _loadGardaSecurity() {
    _gardaSecurity = [
      GardaSecurity('Firewall (UFW)', 'Network protection', true, Icons.firewall, Colors.red),
      GardaSecurity('AppArmor', 'Application confinement', true, Icons.security, Colors.green),
      GardaSecurity('SELinux', 'Mandatory access control', false, Icons.lock, Colors.orange),
      GardaSecurity('Audit System', 'Security logging', true, Icons.history, Colors.blue),
    ];
    _hardenedMode = true;
  }

  void _loadPopFeatures() {
    _popFeatures = [
      PopFeature('Auto Tiling', 'Window tiling manager', true, Icons.grid_view, Colors.cyan),
      PopFeature('Workspaces', 'Multiple workspaces', true, Icons.dashboard, Colors.blue),
      PopFeature('Launcher', 'Application launcher', true, Icons.search, Colors.green),
      PopFeature('Stacking', 'Stack windows', false, Icons.layer, Colors.orange),
    ];
  }

  void _loadFedoraTech() {
    _fedoraTech = [
      FedoraTech('Btrfs', 'Advanced filesystem', true, Icons.storage, Colors.green),
      FedoraTech('Wayland', 'Modern display server', true, Icons.screen, Colors.blue),
      FedoraTech('Flatpak', 'Universal packaging', true, Icons.package, Colors.orange),
      FedoraTech('Podman', 'Container management', true, Icons.docker, Colors.cyan),
    ];
  }

  void _toggleGamingMode() {
    setState(() => _gamingMode = !_gamingMode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_gamingMode ? 'Gaming Mode ON - Performance optimized' : 'Gaming Mode OFF')),
    );
  }

  void _togglePerformanceBoost() {
    setState(() => _performanceBoost = !_performanceBoost);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_performanceBoost ? 'Performance Boost ON - CPU scheduler optimized' : 'Performance Boost OFF')),
    );
  }

  void _toggleHardenedMode() {
    setState(() => _hardenedMode = !_hardenedMode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_hardenedMode ? 'Hardened Mode ON - Maximum security' : 'Hardened Mode OFF')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Distro Integration Hub'),
        backgroundColor: Colors.deepPurple.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.architecture), text: 'Arch'),
            Tab(icon: Icon(Icons.games), text: 'Manjora'),
            Tab(icon: Icon(Icons.speed), text: 'CachyOS'),
            Tab(icon: Icon(Icons.palette), text: 'Zorin'),
            Tab(icon: Icon(Icons.security), text: 'Garda'),
            Tab(icon: Icon(Icons.dashboard), text: 'Pop!_OS'),
            Tab(icon: Icon(Icons.code), text: 'Fedora'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildArchTab(),
          _buildManjoraTab(),
          _buildCachyOSTab(),
          _buildZorinTab(),
          _buildGardaTab(),
          _buildPopTab(),
          _buildFedoraTab(),
        ],
      ),
    );
  }

  Widget _buildArchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan.shade900, Colors.blue.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildArchStat('Packages', '1,245', Colors.cyan),
                _buildArchStat('AUR', '2,890', Colors.blue),
                _buildArchStat('Updates', '23', Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Arch Optimization', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Enable Arch-specific optimizations', style: TextStyle(color: Colors.grey)),
            value: _archOptimized,
            onChanged: (v) => setState(() => _archOptimized = v),
            secondary: const Icon(Icons.speed, color: Colors.cyan),
          ),
          ..._archPackages.map((pkg) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(pkg.icon, color: pkg.color),
              title: Text(pkg.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(pkg.description, style: const TextStyle(color: Colors.grey)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pkg.status == 'Installed' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(pkg.status, style: TextStyle(color: pkg.status == 'Installed' ? Colors.green : Colors.orange)),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildArchStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildManjoraTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple.shade900, Colors.pink.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildManjoraStat('Games Optimized', '245', Colors.purple),
                _buildManjoraStat('FPS Boost', '+35%', Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Gaming Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Optimize system for gaming performance', style: TextStyle(color: Colors.grey)),
            value: _gamingMode,
            onChanged: (_) => _toggleGamingMode(),
            secondary: const Icon(Icons.games, color: Colors.purple),
          ),
          ..._manjoraFeatures.map((feature) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(feature.icon, color: feature.color),
              title: Text(feature.name, style: const TextStyle(color: Colors.white)),
              trailing: Switch(
                value: feature.enabled,
                onChanged: (_) {},
                activeColor: feature.color,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildManjoraStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildCachyOSTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.orange.shade900, Colors.red.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Performance Score', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.89,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.orange,
                      ),
                    ),
                    Text('89%', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Performance Boost', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Enable CachyOS optimizations', style: TextStyle(color: Colors.grey)),
            value: _performanceBoost,
            onChanged: (_) => _togglePerformanceBoost(),
            secondary: const Icon(Icons.speed, color: Colors.orange),
          ),
          ..._cachyOptimizations.map((opt) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(opt.icon, color: opt.color),
              title: Text(opt.name, style: const TextStyle(color: Colors.white)),
              subtitle: LinearProgressIndicator(
                value: opt.score / 100,
                backgroundColor: Colors.grey.shade800,
                color: opt.color,
              ),
              trailing: Text('${opt.score}%', style: const TextStyle(color: opt.color)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildZorinTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.cyan.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonFormField<String>(
              value: _currentTheme,
              items: _zorinThemes.map((theme) => DropdownMenuItem(value: theme.name, child: Text(theme.name))).toList(),
              onChanged: (v) => setState(() => _currentTheme = v!),
              decoration: const InputDecoration(
                labelText: 'Select Theme',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._zorinThemes.map((theme) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(theme.icon, color: Colors.blue),
              title: Text(theme.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(theme.description, style: const TextStyle(color: Colors.grey)),
              trailing: Radio<String>(
                value: theme.name,
                groupValue: _currentTheme,
                onChanged: (v) => setState(() => _currentTheme = v!),
                activeColor: Colors.blue,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildGardaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red.shade900, Colors.orange.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Security Score', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.92,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.green,
                      ),
                    ),
                    Text('92%', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Hardened Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Maximum security enforcement', style: TextStyle(color: Colors.grey)),
            value: _hardenedMode,
            onChanged: (_) => _toggleHardenedMode(),
            secondary: const Icon(Icons.security, color: Colors.red),
          ),
          ..._gardaSecurity.map((sec) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(sec.icon, color: sec.color),
              title: Text(sec.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(sec.description, style: const TextStyle(color: Colors.grey)),
              trailing: Switch(
                value: sec.enabled,
                onChanged: (_) {},
                activeColor: sec.color,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPopTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade900, Colors.teal.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.grid_view, color: Colors.white, size: 40),
                Icon(Icons.dashboard, color: Colors.white, size: 40),
                Icon(Icons.search, color: Colors.white, size: 40),
                Icon(Icons.layer, color: Colors.white, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Workspace Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Enable Pop!_OS workspace features', style: TextStyle(color: Colors.grey)),
            value: _workspaceMode,
            onChanged: (v) => setState(() => _workspaceMode = v),
            secondary: const Icon(Icons.dashboard, color: Colors.green),
          ),
          ..._popFeatures.map((feature) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(feature.icon, color: feature.color),
              title: Text(feature.name, style: const TextStyle(color: Colors.white)),
              trailing: Switch(
                value: feature.enabled,
                onChanged: (_) {},
                activeColor: feature.color,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFedoraTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.indigo.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.storage, color: Colors.white, size: 40),
                Icon(Icons.screen, color: Colors.white, size: 40),
                Icon(Icons.package, color: Colors.white, size: 40),
                Icon(Icons.docker, color: Colors.white, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Bleeding Edge', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Enable latest Fedora technologies', style: TextStyle(color: Colors.grey)),
            value: _bleedingEdge,
            onChanged: (v) => setState(() => _bleedingEdge = v),
            secondary: const Icon(Icons.code, color: Colors.blue),
          ),
          ..._fedoraTech.map((tech) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(tech.icon, color: tech.color),
              title: Text(tech.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(tech.description, style: const TextStyle(color: Colors.grey)),
              trailing: Switch(
                value: tech.enabled,
                onChanged: (_) {},
                activeColor: tech.color,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class ArchPackage {
  final String name;
  final String description;
  final String status;
  final IconData icon;
  final Color color;

  ArchPackage(this.name, this.description, this.status, this.icon, this.color);
}

class ManjoraFeature {
  final String name;
  final String description;
  bool enabled;
  final IconData icon;
  final Color color;

  ManjoraFeature(this.name, this.description, this.enabled, this.icon, this.color);
}

class CachyOptimization {
  final String name;
  final String description;
  final double score;
  final IconData icon;
  final Color color;

  CachyOptimization(this.name, this.description, this.score, this.icon, this.color);
}

class ZorinTheme {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  ZorinTheme(this.name, this.description, this.icon, this.color);
}

class GardaSecurity {
  final String name;
  final String description;
  bool enabled;
  final IconData icon;
  final Color color;

  GardaSecurity(this.name, this.description, this.enabled, this.icon, this.color);
}

class PopFeature {
  final String name;
  final String description;
  bool enabled;
  final IconData icon;
  final Color color;

  PopFeature(this.name, this.description, this.enabled, this.icon, this.color);
}

class FedoraTech {
  final String name;
  final String description;
  bool enabled;
  final IconData icon;
  final Color color;

  FedoraTech(this.name, this.description, this.enabled, this.icon, this.color);
}
