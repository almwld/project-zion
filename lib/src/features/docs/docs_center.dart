import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class DocsCenter extends StatefulWidget {
  const DocsCenter({super.key});

  @override
  State<DocsCenter> createState() => _DocsCenterState();
}

class _DocsCenterState extends State<DocsCenter> {
  int _selectedTab = 0;
  String _searchQuery = '';
  
  List<DocItem> _docs = [];
  List<DocItem> _filteredDocs = [];
  List<DocCategory> _categories = [];
  List<DocFavorite> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadDocs();
    _loadCategories();
    _loadFavorites();
  }

  void _loadDocs() {
    _docs = [
      DocItem(
        id: '1',
        title: 'Getting Started with Zion OS',
        content: 'Complete guide to install and configure Zion OS on your device...',
        category: 'Getting Started',
        author: 'Zion Team',
        date: DateTime.now().subtract(const Duration(days: 5)),
        readTime: '10 min',
        icon: Icons.rocket_launch,
        color: Colors.green,
      ),
      DocItem(
        id: '2',
        title: 'SI Agent User Guide',
        content: 'Learn how to configure and use the Sentient Intelligence Agent...',
        category: 'AI & Automation',
        author: 'AI Team',
        date: DateTime.now().subtract(const Duration(days: 10)),
        readTime: '15 min',
        icon: Icons.psychology,
        color: Colors.purple,
      ),
      DocItem(
        id: '3',
        title: 'Network Scanning Techniques',
        content: 'Advanced network reconnaissance and scanning methodologies...',
        category: 'Network Security',
        author: 'Security Team',
        date: DateTime.now().subtract(const Duration(days: 15)),
        readTime: '20 min',
        icon: Icons.network_check,
        color: Colors.cyan,
      ),
      DocItem(
        id: '4',
        title: 'API Integration Guide',
        content: 'Connect Zion OS with external services and APIs...',
        category: 'Development',
        author: 'Dev Team',
        date: DateTime.now().subtract(const Duration(days: 20)),
        readTime: '12 min',
        icon: Icons.api,
        color: Colors.blue,
      ),
      DocItem(
        id: '5',
        title: 'Security Best Practices',
        content: 'Essential security measures to protect your system...',
        category: 'Security',
        author: 'Security Team',
        date: DateTime.now().subtract(const Duration(days: 25)),
        readTime: '8 min',
        icon: Icons.security,
        color: Colors.red,
      ),
    ];
    _filteredDocs = _docs;
  }

  void _loadCategories() {
    _categories = [
      DocCategory('Getting Started', 5, Icons.rocket_launch, Colors.green),
      DocCategory('AI & Automation', 8, Icons.psychology, Colors.purple),
      DocCategory('Network Security', 12, Icons.network_check, Colors.cyan),
      DocCategory('Development', 6, Icons.code, Colors.blue),
      DocCategory('Security', 4, Icons.security, Colors.red),
      DocCategory('Troubleshooting', 7, Icons.bug_report, Colors.orange),
    ];
  }

  void _loadFavorites() {
    _favorites = [
      DocFavorite('1', 'Getting Started with Zion OS', Icons.star, Colors.yellow),
      DocFavorite('3', 'Network Scanning Techniques', Icons.star, Colors.yellow),
    ];
  }

  void _searchDocs(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredDocs = _docs;
      } else {
        _filteredDocs = _docs.where((doc) =>
          doc.title.toLowerCase().contains(query.toLowerCase()) ||
          doc.content.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  void _openDoc(DocItem doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(doc.title),
        backgroundColor: Colors.grey.shade900,
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(doc.icon, color: doc.color),
                    const SizedBox(width: 8),
                    Text('${doc.readTime} read', style: const TextStyle(color: Colors.grey)),
                    const Spacer(),
                    Text('By ${doc.author}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(doc.content, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Text('Last updated: ${_formatDate(doc.date)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Share.share(doc.content),
            child: const Text('Share'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(String id, String title) {
    setState(() {
      if (_favorites.any((f) => f.id == id)) {
        _favorites.removeWhere((f) => f.id == id);
      } else {
        _favorites.add(DocFavorite(id, title, Icons.star, Colors.yellow));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Documentation Center'),
        backgroundColor: Colors.orange.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.grey.shade900,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Documentation',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.white24),
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                return ListTile(
                  leading: Icon(cat.icon, color: cat.color),
                  title: Text(cat.name, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${cat.count}', style: const TextStyle(color: Colors.grey)),
                  onTap: () => setState(() => _selectedTab = i),
                  selected: _selectedTab == i,
                  selectedTileColor: Colors.orange.withOpacity(0.2),
                );
              },
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.yellow),
            title: const Text('Favorites', style: TextStyle(color: Colors.white)),
            onTap: () => setState(() => _selectedTab = -1),
            selected: _selectedTab == -1,
            selectedTileColor: Colors.orange.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedTab == -1) {
      return _buildFavoritesTab();
    }
    
    final category = _categories[_selectedTab];
    final categoryDocs = _docs.where((d) => d.category == category.name).toList();
    
    return _buildDocsList(categoryDocs);
  }

  Widget _buildFavoritesTab() {
    if (_favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text('No favorites yet', style: TextStyle(color: Colors.grey)),
            Text('Star documents to save them here', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favorites.length,
      itemBuilder: (ctx, i) {
        final favorite = _favorites[i];
        final doc = _docs.firstWhere((d) => d.id == favorite.id, orElse: () => _docs.first);
        return _buildDocCard(doc, true);
      },
    );
  }

  Widget _buildDocsList(List<DocItem> docs) {
    if (_searchQuery.isNotEmpty && _filteredDocs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text('No documents found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    
    final displayDocs = _searchQuery.isEmpty ? docs : _filteredDocs;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayDocs.length,
      itemBuilder: (ctx, i) => _buildDocCard(displayDocs[i], _favorites.any((f) => f.id == displayDocs[i].id)),
    );
  }

  Widget _buildDocCard(DocItem doc, bool isFavorite) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: doc.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(doc.icon, color: doc.color),
        ),
        title: Text(doc.title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          '${doc.category} • ${doc.readTime} • ${_formatDate(doc.date)}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isFavorite ? Icons.star : Icons.star_border, color: Colors.yellow),
              onPressed: () => _toggleFavorite(doc.id, doc.title),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onPressed: () => _openDoc(doc),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search Documentation'),
        backgroundColor: Colors.grey.shade900,
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _searchDocs(value);
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class DocItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final String author;
  final DateTime date;
  final String readTime;
  final IconData icon;
  final Color color;

  DocItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.author,
    required this.date,
    required this.readTime,
    required this.icon,
    required this.color,
  });
}

class DocCategory {
  final String name;
  final int count;
  final IconData icon;
  final Color color;

  DocCategory(this.name, this.count, this.icon, this.color);
}

class DocFavorite {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  DocFavorite(this.id, this.title, this.icon, this.color);
}
