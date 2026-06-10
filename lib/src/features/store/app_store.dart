import 'package:flutter/material.dart';

class AppStore extends StatefulWidget {
  const AppStore({super.key});

  @override
  State<AppStore> createState() => _AppStoreState();
}

class _AppStoreState extends State<AppStore> {
  String _selectedCategory = 'Featured';
  List<StoreApp> _apps = [];
  List<StoreApp> _installedApps = [];
  List<StorePlugin> _plugins = [];

  final List<String> _categories = ['Featured', 'Tools', 'Games', 'Plugins', 'Updates', 'Installed'];

  @override
  void initState() {
    super.initState();
    _loadApps();
    _loadPlugins();
    _loadInstalled();
  }

  void _loadApps() {
    _apps = [
      StoreApp(
        id: '1',
        name: 'ZionNet Pro',
        description: 'Advanced network scanning and analysis tool',
        category: 'Tools',
        size: '15 MB',
        rating: 4.8,
        downloads: '10K+',
        price: 'Free',
        icon: Icons.network_check,
        color: Colors.cyan,
        isInstalled: false,
      ),
      StoreApp(
        id: '2',
        name: 'AI Attack Assistant',
        description: 'AI-powered attack recommendations and automation',
        category: 'Tools',
        size: '28 MB',
        rating: 4.9,
        downloads: '5K+',
        price: 'Free',
        icon: Icons.psychology,
        color: Colors.purple,
        isInstalled: false,
      ),
      StoreApp(
        id: '3',
        name: 'ZionCrack Ultimate',
        description: 'Password cracking with GPU acceleration',
        category: 'Tools',
        size: '42 MB',
        rating: 4.7,
        downloads: '8K+',
        price: 'Free',
        icon: Icons.lock,
        color: Colors.red,
        isInstalled: false,
      ),
      StoreApp(
        id: '4',
        name: 'Memory Match Plus',
        description: 'Enhanced memory game with new levels',
        category: 'Games',
        size: '12 MB',
        rating: 4.6,
        downloads: '2K+',
        price: 'Free',
        icon: Icons.games,
        color: Colors.amber,
        isInstalled: false,
      ),
      StoreApp(
        id: '5',
        name: 'Network Monitor Pro',
        description: 'Real-time network traffic analysis',
        category: 'Tools',
        size: '18 MB',
        rating: 4.8,
        downloads: '3K+',
        price: 'Free',
        icon: Icons.analytics,
        color: Colors.green,
        isInstalled: false,
      ),
    ];
  }

  void _loadPlugins() {
    _plugins = [
      StorePlugin(
        id: 'p1',
        name: 'Dark Web Scanner',
        description: 'Scan dark web for compromised credentials',
        version: '1.0.0',
        size: '8 MB',
        compatible: 'Zion OS v3.3+',
        icon: Icons.dark_mode,
        color: Colors.grey,
      ),
      StorePlugin(
        id: 'p2',
        name: 'Vulnerability Database',
        description: 'Real-time CVE database integration',
        version: '2.1.0',
        size: '25 MB',
        compatible: 'Zion OS v3.0+',
        icon: Icons.security,
        color: Colors.red,
      ),
      StorePlugin(
        id: 'p3',
        name: 'Cloud Backup Sync',
        description: 'Automatic backup to cloud storage',
        version: '1.2.0',
        size: '10 MB',
        compatible: 'Zion OS v3.2+',
        icon: Icons.cloud_upload,
        color: Colors.blue,
      ),
    ];
  }

  void _loadInstalled() {
    _installedApps = [
      StoreApp(
        id: 'inst1',
        name: 'Zion Terminal',
        description: 'Cosmic terminal with AI assistance',
        category: 'Tools',
        size: '25 MB',
        rating: 5.0,
        downloads: '50K+',
        price: 'Free',
        icon: Icons.terminal,
        color: Colors.green,
        isInstalled: true,
      ),
      StoreApp(
        id: 'inst2',
        name: 'SI Agent Core',
        description: 'Sentient Intelligence Agent',
        category: 'Tools',
        size: '35 MB',
        rating: 4.9,
        downloads: '45K+',
        price: 'Free',
        icon: Icons.psychology,
        color: Colors.purple,
        isInstalled: true,
      ),
    ];
  }

  void _installApp(StoreApp app) {
    setState(() {
      app.isInstalled = true;
      _installedApps.add(app);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${app.name} installed successfully!')),
    );
  }

  void _uninstallApp(StoreApp app) {
    setState(() {
      app.isInstalled = false;
      _installedApps.removeWhere((a) => a.id == app.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${app.name} uninstalled successfully!')),
    );
  }

  void _installPlugin(StorePlugin plugin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${plugin.name} installed! Restart required.')),
    );
  }

  List<StoreApp> get _displayedApps {
    if (_selectedCategory == 'Featured') {
      return _apps.where((a) => a.rating >= 4.8).toList();
    } else if (_selectedCategory == 'Installed') {
      return _installedApps;
    } else if (_selectedCategory == 'Plugins') {
      return [];
    } else if (_selectedCategory == 'Updates') {
      return [];
    }
    return _apps.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('App Store'),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildCategoryFilter()),
          SliverToBoxAdapter(child: _buildFeaturedBanner()),
          SliverToBoxAdapter(child: _buildSectionHeader('Recommended for You')),
          SliverToBoxAdapter(child: _buildAppsList()),
          if (_selectedCategory == 'Plugins') ...[
            SliverToBoxAdapter(child: _buildSectionHeader('Available Plugins')),
            SliverToBoxAdapter(child: _buildPluginsList()),
          ],
          if (_selectedCategory == 'Updates') ...[
            SliverToBoxAdapter(child: _buildSectionHeader('Updates Available')),
            SliverToBoxAdapter(child: _buildUpdatesList()),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (ctx, i) {
          final category = _categories[i];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: Colors.grey.shade800,
              selectedColor: Colors.blue,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade900, Colors.purple.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20,
            top: 20,
            child: Icon(Icons.stars, color: Colors.yellow, size: 50),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Special Offer', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Get ZionNet Pro for free!', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Download Now', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAppsList() {
    if (_displayedApps.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No apps found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _displayedApps.length,
      itemBuilder: (ctx, i) {
        final app = _displayedApps[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: app.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(app.icon, color: app.color, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(app.description, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 2),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 14),
                        const SizedBox(width: 2),
                        Text('${app.rating}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(width: 8),
                        Text(app.size, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(width: 8),
                        Text(app.downloads, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              if (app.isInstalled)
                OutlinedButton(
                  onPressed: () => _uninstallApp(app),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Uninstall'),
                )
              else
                ElevatedButton(
                  onPressed: () => _installApp(app),
                  style: ElevatedButton.styleFrom(backgroundColor: app.color),
                  child: const Text('Install'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPluginsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _plugins.length,
      itemBuilder: (ctx, i) {
        final plugin = _plugins[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: plugin.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(plugin.icon, color: plugin.color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plugin.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(plugin.description, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 2),
                    Text('v${plugin.version} • ${plugin.size} • ${plugin.compatible}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _installPlugin(plugin),
                style: ElevatedButton.styleFrom(backgroundColor: plugin.color),
                child: const Text('Install'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpdatesList() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('All apps are up to date', style: TextStyle(color: Colors.green)),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search Apps'),
        backgroundColor: Colors.grey.shade900,
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Search')),
        ],
      ),
    );
  }
}

class StoreApp {
  final String id;
  final String name;
  final String description;
  final String category;
  final String size;
  final double rating;
  final String downloads;
  final String price;
  final IconData icon;
  final Color color;
  bool isInstalled;

  StoreApp({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.size,
    required this.rating,
    required this.downloads,
    required this.price,
    required this.icon,
    required this.color,
    required this.isInstalled,
  });
}

class StorePlugin {
  final String id;
  final String name;
  final String description;
  final String version;
  final String size;
  final String compatible;
  final IconData icon;
  final Color color;

  StorePlugin({
    required this.id,
    required this.name,
    required this.description,
    required this.version,
    required this.size,
    required this.compatible,
    required this.icon,
    required this.color,
  });
}
