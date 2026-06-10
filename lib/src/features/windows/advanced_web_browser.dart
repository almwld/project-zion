import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class AdvancedWebBrowser extends StatefulWidget {
  const AdvancedWebBrowser({super.key});

  @override
  State<AdvancedWebBrowser> createState() => _AdvancedWebBrowserState();
}

class _AdvancedWebBrowserState extends State<AdvancedWebBrowser> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<BrowserTab> _tabs = [];
  int _nextTabId = 1;
  bool _isLoading = false;
  String _currentUrl = 'https://www.google.com';

  @override
  void initState() {
    super.initState();
    _addNewTab();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  void _addNewTab() {
    final newTab = BrowserTab(
      id: _nextTabId++,
      title: 'New Tab',
      url: 'https://www.google.com',
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() {
                _currentUrl = url;
                _isLoading = true;
                final index = _tabs.indexWhere((t) => t.id == newTab.id);
                if (index != -1) {
                  _tabs[index].title = _extractTitleFromUrl(url);
                  _tabs[index].url = url;
                }
              });
            },
            onPageFinished: (url) {
              setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(Uri.parse('https://www.google.com')),
    );
    setState(() {
      _tabs.add(newTab);
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.animateTo(_tabs.length - 1);
    });
  }

  void _closeTab(int index) {
    setState(() {
      _tabs.removeAt(index);
      _tabController = TabController(length: _tabs.length, vsync: this);
      if (_tabs.isNotEmpty && index > 0) {
        _tabController.animateTo(index - 1);
      }
    });
  }

  String _extractTitleFromUrl(String url) {
    final parts = url.replaceFirst('https://', '').replaceFirst('http://', '').split('.');
    if (parts.isNotEmpty) return parts[0];
    return 'Tab';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildTabBar(),
          _buildAddressBar(),
          Expanded(
            child: _tabs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: _tabs.map((tab) => WebViewWidget(controller: tab.controller)).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.grey.shade900,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: _tabs.map((tab) => Tab(
                    child: Row(
                      children: [
                        const Icon(Icons.tab, size: 16),
                        const SizedBox(width: 4),
                        Text(tab.title, maxLines: 1),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _closeTab(_tabs.indexOf(tab)),
                          child: const Icon(Icons.close, size: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: _addNewTab,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade800,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              final currentTab = _tabs[_tabController.index];
              if (currentTab.controller != null) {
                currentTab.controller!.goBack();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              final currentTab = _tabs[_tabController.index];
              if (currentTab.controller != null) {
                currentTab.controller!.goForward();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              final currentTab = _tabs[_tabController.index];
              if (currentTab.controller != null) {
                currentTab.controller!.reload();
              }
            },
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: TextEditingController(text: _currentUrl),
              decoration: InputDecoration(
                hintText: 'Enter URL',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black,
                suffixIcon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
              onSubmitted: (url) {
                var finalUrl = url;
                if (!url.startsWith('http')) {
                  finalUrl = 'https://$url';
                }
                final currentTab = _tabs[_tabController.index];
                currentTab.controller?.loadRequest(Uri.parse(finalUrl));
                setState(() => _currentUrl = finalUrl);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.amber),
            onPressed: () => _showBookmarks(),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showMenu(),
          ),
        ],
      ),
    );
  }

  void _showBookmarks() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bookmarks'),
        backgroundColor: Colors.grey.shade900,
        content: const Text('Bookmarks feature coming soon', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _showHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.green),
              title: const Text('Downloads', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _showDownloads();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.orange),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _showBrowserSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.cyan),
              title: const Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _showAbout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('History'),
        backgroundColor: Colors.grey.shade900,
        content: const Text('History feature coming soon', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showDownloads() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Downloads'),
        backgroundColor: Colors.grey.shade900,
        content: const Text('Downloads feature coming soon', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showBrowserSettings() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Browser Settings'),
        backgroundColor: Colors.grey.shade900,
        content: const Text('Settings coming soon', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Zion Browser'),
        backgroundColor: Colors.grey.shade900,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Version: 1.0', style: TextStyle(color: Colors.white)),
            Text('Engine: WebView Flutter', style: TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}

class BrowserTab {
  final int id;
  String title;
  String url;
  final WebViewController controller;

  BrowserTab({
    required this.id,
    required this.title,
    required this.url,
    required this.controller,
  });
}
