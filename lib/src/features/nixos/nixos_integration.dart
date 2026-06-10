import 'package:flutter/material.dart';
import 'dart:async';

class NixOSIntegration extends StatefulWidget {
  const NixOSIntegration({super.key});

  @override
  State<NixOSIntegration> createState() => _NixOSIntegrationState();
}

class _NixOSIntegrationState extends State<NixOSIntegration> {
  int _selectedTab = 0;
  
  // Nix Packages Management
  List<NixPackage> _installedPackages = [];
  List<NixPackage> _availablePackages = [];
  int _totalPackages = 0;
  int _updateCount = 0;
  
  // NixOS Configuration
  Map<String, dynamic> _nixConfig = {};
  List<String> _enabledFeatures = [];
  bool _declarativeMode = true;
  bool _reproducibleBuilds = true;
  
  // Flakes (Modern Nix)
  List<NixFlake> _flakes = [];
  bool _flakesEnabled = true;
  
  // Nix Shell Environments
  List<NixShell> _shells = [];
  String _currentShell = '';
  
  // NixOS Modules
  List<NixModule> _modules = [];
  List<String> _activeModules = [];

  @override
  void initState() {
    super.initState();
    _loadPackages();
    _loadNixConfig();
    _loadFlakes();
    _loadShells();
    _loadModules();
  }

  void _loadPackages() {
    _installedPackages = [
      NixPackage('nixpkgs', '24.11', 'Installed', Icons.package, Colors.blue, 2450),
      NixPackage('home-manager', 'release-24.11', 'Installed', Icons.home, Colors.green, 125),
      NixPackage('nix-darwin', 'main', 'Available', Icons.apple, Colors.grey, 89),
    ];
    
    _availablePackages = [
      NixPackage('neovim', '0.9.5', 'Not Installed', Icons.edit, Colors.orange, 45),
      NixPackage('git', '2.42.0', 'Not Installed', Icons.code, Colors.blue, 12),
      NixPackage('nodejs', '20.10.0', 'Not Installed', Icons.javascript, Colors.green, 89),
    ];
    
    _totalPackages = 2450;
    _updateCount = 23;
  }

  void _loadNixConfig() {
    _nixConfig = {
      'allowUnfree': true,
      'experimentalFeatures': ['flakes', 'nix-command'],
      'substituters': ['https://cache.nixos.org'],
      'sandbox': true,
      'maxJobs': 8,
    };
    
    _enabledFeatures = ['Flakes', 'Nix Command', 'Remote Builds', 'Binary Caches'];
  }

  void _loadFlakes() {
    _flakes = [
      NixFlake('nixpkgs', 'github:NixOS/nixpkgs/nixos-24.11', 'Updated', Icons.code, Colors.blue, '24.11'),
      NixFlake('home-manager', 'github:nix-community/home-manager', 'Updated', Icons.home, Colors.green, 'release-24.11'),
      NixFlake('dev-shell', 'github:DeterminateSystems/devshell', 'Pending', Icons.terminal, Colors.orange, 'main'),
    ];
  }

  void _loadShells() {
    _shells = [
      NixShell('Python Dev', 'python311, pip, poetry', 'Active', Icons.python, Colors.blue, 5),
      NixShell('Node.js Dev', 'nodejs_20, npm, yarn', 'Active', Icons.javascript, Colors.green, 8),
      NixShell('Rust Dev', 'rustc, cargo, clippy', 'Inactive', Icons.code, Colors.orange, 12),
    ];
    _currentShell = 'Python Dev';
  }

  void _loadModules() {
    _modules = [
      NixModule('networking', 'Network configuration', true, Icons.wifi, Colors.blue),
      NixModule('security', 'Security policies', true, Icons.security, Colors.red),
      NixModule('services', 'System services', false, Icons.settings, Colors.green),
      NixModule('virtualisation', 'Docker, Podman', true, Icons.docker, Colors.cyan),
    ];
    _activeModules = _modules.where((m) => m.enabled).map((m) => m.name).toList();
  }

  void _installPackage(NixPackage pkg) {
    setState(() {
      pkg.status = 'Installed';
      _installedPackages.add(pkg);
      _availablePackages.remove(pkg);
      _totalPackages++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Installed: ${pkg.name}')),
    );
  }

  void _updateFlake(NixFlake flake) {
    setState(() {
      flake.status = 'Updated';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updated: ${flake.name}')),
    );
  }

  void _activateShell(NixShell shell) {
    setState(() {
      _currentShell = shell.name;
      for (var s in _shells) {
        s.status = s.name == shell.name ? 'Active' : 'Inactive';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activated: ${shell.name} environment')),
    );
  }

  void _toggleModule(NixModule module) {
    setState(() {
      module.enabled = !module.enabled;
      if (module.enabled) {
        _activeModules.add(module.name);
      } else {
        _activeModules.remove(module.name);
      }
    });
  }

  void _rebuildSystem() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rebuild System'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Running: nixos-rebuild switch', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            LinearProgressIndicator(),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('System rebuilt successfully!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('NixOS Integration'),
        backgroundColor: Colors.indigo.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.package), text: 'Packages'),
            Tab(icon: Icon(Icons.settings), text: 'Config'),
            Tab(icon: Icon(Icons.token), text: 'Flakes'),
            Tab(icon: Icon(Icons.terminal), text: 'Shells'),
            Tab(icon: Icon(Icons.build), text: 'Modules'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildPackagesTab(),
          _buildConfigTab(),
          _buildFlakesTab(),
          _buildShellsTab(),
          _buildModulesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _rebuildSystem,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.build),
      ),
    );
  }

  Widget _buildPackagesTab() {
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
                colors: [Colors.indigo.shade900, Colors.blue.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPackageStat('Installed', '$_totalPackages', Colors.green),
                _buildPackageStat('Updates', '$_updateCount', Colors.orange),
                _buildPackageStat('Available', '${_availablePackages.length}', Colors.cyan),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Installed Packages', style: TextStyle(color: Colors.white, fontSize: 18)),
          ..._installedPackages.map((pkg) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(pkg.icon, color: pkg.color),
              title: Text(pkg.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text('Version: ${pkg.version} • ${pkg.size} MB', style: const TextStyle(color: Colors.grey)),
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
          const SizedBox(height: 16),
          const Text('Available Packages', style: TextStyle(color: Colors.white, fontSize: 18)),
          ..._availablePackages.map((pkg) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(pkg.icon, color: pkg.color),
              title: Text(pkg.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text('Version: ${pkg.version} • ${pkg.size} MB', style: const TextStyle(color: Colors.grey)),
              trailing: ElevatedButton(
                onPressed: () => _installPackage(pkg),
                style: ElevatedButton.styleFrom(backgroundColor: pkg.color),
                child: const Text('Install'),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPackageStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildConfigTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Declarative Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Use declarative configuration', style: TextStyle(color: Colors.grey)),
            value: _declarativeMode,
            onChanged: (v) => setState(() => _declarativeMode = v),
            secondary: const Icon(Icons.description, color: Colors.blue),
          ),
          SwitchListTile(
            title: const Text('Reproducible Builds', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Ensure bit-for-bit reproducible builds', style: TextStyle(color: Colors.grey)),
            value: _reproducibleBuilds,
            onChanged: (v) => setState(() => _reproducibleBuilds = v),
            secondary: const Icon(Icons.repeat, color: Colors.green),
          ),
          const Divider(color: Colors.white24),
          const Text('Enabled Features', style: TextStyle(color: Colors.white, fontSize: 18)),
          ..._enabledFeatures.map((feature) => ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(feature, style: const TextStyle(color: Colors.white)),
          )),
          const Divider(color: Colors.white24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text('Configuration.nix', style: TextStyle(color: Colors.cyan)),
                const SizedBox(height: 8),
                Text(
                  '{ config, pkgs, ... }:\n{\n  imports = [ ./hardware-configuration.nix ];\n  boot.loader.systemd-boot.enable = true;\n  networking.hostName = "zion";\n  environment.systemPackages = with pkgs; [ git vim ];\n}',
                  style: const TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlakesTab() {
    return ListView.builder(
      itemCount: _flakes.length,
      itemBuilder: (ctx, i) {
        final flake = _flakes[i];
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.all(16),
          child: ListTile(
            leading: Icon(flake.icon, color: flake.color),
            title: Text(flake.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('URL: ${flake.url} • Version: ${flake.version}', style: const TextStyle(color: Colors.grey)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: flake.status == 'Updated' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(flake.status, style: TextStyle(color: flake.status == 'Updated' ? Colors.green : Colors.orange)),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.cyan),
                  onPressed: () => _updateFlake(flake),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShellsTab() {
    return ListView.builder(
      itemCount: _shells.length,
      itemBuilder: (ctx, i) {
        final shell = _shells[i];
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.all(16),
          child: ListTile(
            leading: Icon(shell.icon, color: shell.color),
            title: Text(shell.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('Packages: ${shell.packages} • Size: ${shell.size} MB', style: const TextStyle(color: Colors.grey)),
            trailing: ElevatedButton(
              onPressed: () => _activateShell(shell),
              style: ElevatedButton.styleFrom(
                backgroundColor: shell.status == 'Active' ? Colors.green : Colors.blue,
              ),
              child: Text(shell.status),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModulesTab() {
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
              const Text('Active Modules', style: TextStyle(color: Colors.white)),
              const Divider(),
              Wrap(
                spacing: 8,
                children: _activeModules.map((module) => Chip(
                  label: Text(module),
                  backgroundColor: Colors.indigo,
                )).toList(),
              ),
            ],
          ),
        ),
        ..._modules.map((module) => Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SwitchListTile(
            title: Text(module.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(module.description, style: const TextStyle(color: Colors.grey)),
            secondary: Icon(module.icon, color: module.color),
            value: module.enabled,
            onChanged: (_) => _toggleModule(module),
          ),
        )),
      ],
    );
  }
}

class NixPackage {
  final String name;
  final String version;
  String status;
  final IconData icon;
  final Color color;
  final int size;

  NixPackage(this.name, this.version, this.status, this.icon, this.color, this.size);
}

class NixFlake {
  final String name;
  final String url;
  String status;
  final IconData icon;
  final Color color;
  final String version;

  NixFlake(this.name, this.url, this.status, this.icon, this.color, this.version);
}

class NixShell {
  final String name;
  final String packages;
  String status;
  final IconData icon;
  final Color color;
  final int size;

  NixShell(this.name, this.packages, this.status, this.icon, this.color, this.size);
}

class NixModule {
  final String name;
  final String description;
  bool enabled;
  final IconData icon;
  final Color color;

  NixModule(this.name, this.description, this.enabled, this.icon, this.color);
}

// ==================== خدمات NixOS ====================
class NixService {
  final String name;
  final String description;
  bool enabled;
  final String status;
  final IconData icon;
  final Color color;

  NixService(this.name, this.description, this.enabled, this.status, this.icon, this.color);
}

// إضافة في _loadServices
void _loadServices() {
  _services = [
    NixService('nginx', 'Web server', true, 'Running', Icons.public, Colors.blue),
    NixService('postgresql', 'Database', true, 'Running', Icons.storage, Colors.cyan),
    NixService('redis', 'Cache', false, 'Stopped', Icons.speed, Colors.red),
    NixService('docker', 'Container runtime', true, 'Running', Icons.docker, Colors.blue),
  ];
}

// إضافة في build
Widget _buildServicesTab() {
  return ListView.builder(
    itemCount: _services.length,
    itemBuilder: (ctx, i) {
      final service = _services[i];
      return Card(
        color: Colors.grey.shade900,
        margin: const EdgeInsets.all(16),
        child: ListTile(
          leading: Icon(service.icon, color: service.color),
          title: Text(service.name, style: const TextStyle(color: Colors.white)),
          subtitle: Text(service.description, style: const TextStyle(color: Colors.grey)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: service.status == 'Running' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(service.status, style: TextStyle(color: service.status == 'Running' ? Colors.green : Colors.red)),
              ),
              const SizedBox(width: 8),
              Switch(
                value: service.enabled,
                onChanged: (_) {},
                activeColor: service.color,
              ),
            ],
          ),
        ),
      );
    },
  );
}

// إضافة الـ tab
Tab(icon: Icon(Icons.miscellaneous_services), text: 'Services'),
// وإضافة في IndexedStack
_buildServicesTab(),

// ==================== Nix Overlays ====================
class NixOverlay {
  final String name;
  final String description;
  bool enabled;
  final String priority;
  final IconData icon;
  final Color color;

  NixOverlay(this.name, this.description, this.enabled, this.priority, this.icon, this.color);
}

void _loadOverlays() {
  _overlays = [
    NixOverlay('nixpkgs-unstable', 'Latest unstable packages', true, 'High', Icons.update, Colors.orange),
    NixOverlay('nixos-hardware', 'Hardware optimizations', true, 'Medium', Icons.computer, Colors.blue),
    NixOverlay('nix-community', 'Community packages', false, 'Low', Icons.people, Colors.green),
  ];
}

Widget _buildOverlaysTab() {
  return ListView.builder(
    itemCount: _overlays.length,
    itemBuilder: (ctx, i) {
      final overlay = _overlays[i];
      return Card(
        color: Colors.grey.shade900,
        margin: const EdgeInsets.all(16),
        child: ListTile(
          leading: Icon(overlay.icon, color: overlay.color),
          title: Text(overlay.name, style: const TextStyle(color: Colors.white)),
          subtitle: Text('${overlay.description} • Priority: ${overlay.priority}', style: const TextStyle(color: Colors.grey)),
          trailing: Switch(
            value: overlay.enabled,
            onChanged: (_) {},
            activeColor: overlay.color,
          ),
        ),
      );
    },
  );
}

// إضافة الـ tab
Tab(icon: Icon(Icons.layer), text: 'Overlays'),
_buildOverlaysTab(),

// ==================== Garbage Collection ====================
int _storeSize = 0;
int _garbageSize = 0;
int _optimizationScore = 0;

void _loadStoreStats() {
  _storeSize = 2450;
  _garbageSize = 320;
  _optimizationScore = 87;
}

void _runGarbageCollection() {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Garbage Collection'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Running: nix-collect-garbage -d', style: TextStyle(color: Colors.white)),
          SizedBox(height: 16),
          LinearProgressIndicator(),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
    ),
  );
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.pop(context);
    setState(() {
      _garbageSize = 0;
      _storeSize -= 320;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Garbage collection completed! Freed 320 MB')),
    );
  });
}

void _optimizeStore() {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Optimizing Store'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Running: nix-store --optimise', style: TextStyle(color: Colors.white)),
          SizedBox(height: 16),
          LinearProgressIndicator(),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
    ),
  );
  Future.delayed(const Duration(seconds: 4), () {
    Navigator.pop(context);
    setState(() {
      _optimizationScore = 94;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Store optimized! Deduplication completed.')),
    );
  });
}

Widget _buildStoreTab() {
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
              colors: [Colors.cyan.shade900, Colors.teal.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Nix Store', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStoreStat('Store Size', '${_storeSize} MB', Colors.cyan),
                  _buildStoreStat('Garbage', '${_garbageSize} MB', Colors.red),
                  _buildStoreStat('Optimization', '${_optimizationScore}%', Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _runGarbageCollection,
                      icon: const Icon(Icons.delete),
                      label: const Text('GC'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _optimizeStore,
                      icon: const Icon(Icons.speed),
                      label: const Text('Optimize'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildStoreStat(String label, String value, Color color) {
  return Column(
    children: [
      Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      Text(label, style: const TextStyle(color: Colors.white70)),
    ],
  );
}

// إضافة الـ tab
Tab(icon: Icon(Icons.storage), text: 'Store'),
_buildStoreTab(),
