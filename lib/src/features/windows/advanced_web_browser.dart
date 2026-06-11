import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class AdvancedWebBrowser extends StatefulWidget {
  const AdvancedWebBrowser({super.key});

  @override
  State<AdvancedWebBrowser> createState() => _AdvancedWebBrowserState();
}

class _AdvancedWebBrowserState extends State<AdvancedWebBrowser> {
  final TextEditingController _urlController = TextEditingController();
  final List<String> _history = [];
  final List<String> _bookmarks = [];
  String _currentUrl = 'https://www.google.com';
  bool _isLoading = false;
  bool _isPrivateMode = false;

  @override
  void initState() {
    super.initState();
    _urlController.text = _currentUrl;
    _loadBookmarks();
  }

  void _loadBookmarks() {
    _bookmarks.addAll([
      'https://www.google.com',
      'https://www.github.com',
      'https://www.wikipedia.org',
    ]);
  }

  Future<void> _loadUrl(String url) async {
    var finalUrl = url;
    if (!url.startsWith('http')) {
      finalUrl = 'https://$url';
    }
    
    setState(() {
      _currentUrl = finalUrl;
      _isLoading = true;
    });
    
    _urlController.text = finalUrl;
    if (!_isPrivateMode) {
      _history.add(finalUrl);
    }
    
    final uri = Uri.parse(finalUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load URL')),
      );
    }
    
    setState(() => _isLoading = false);
  }

  void _goBack() {
    if (_history.length > 1) {
      _history.removeLast();
      _loadUrl(_history.last);
    }
  }

  void _addBookmark() {
    if (!_bookmarks.contains(_currentUrl)) {
      setState(() {
        _bookmarks.add(_currentUrl);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark added')),
      );
    }
  }

  void _togglePrivateMode() {
    setState(() {
      _isPrivateMode = !_isPrivateMode;
      if (_isPrivateMode) {
        _history.clear();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isPrivateMode ? 'Private Mode ON' : 'Private Mode OFF')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Zion Browser'),
        backgroundColor: Colors.teal.shade900,
        actions: [
          IconButton(
            icon: Icon(_isPrivateMode ? Icons.visibility_off : Icons.visibility),
            onPressed: _togglePrivateMode,
            tooltip: 'Private Mode',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: _addBookmark,
            tooltip: 'Add Bookmark',
          ),
        ],
      ),
      body: Column(
        children: [
          // Address Bar
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade900,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _history.length > 1 ? _goBack : null,
                ),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    style: const TextStyle(color: Colors.white),
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
                    onSubmitted: _loadUrl,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => _loadUrl(_currentUrl),
                ),
              ],
            ),
          ),
          
          // Bookmarks Bar
          Container(
            height: 40,
            color: Colors.grey.shade800,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _bookmarks.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => _loadUrl(_bookmarks[i]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      _extractDomain(_bookmarks[i]),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Web View (WebView replacement)
          Expanded(
            child: Container(
              color: Colors.grey.shade900,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.public, color: Colors.teal, size: 80),
                    const SizedBox(height: 20),
                    const Text(
                      'Zion Browser',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter a URL above to browse',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                    const SizedBox(height: 20),
                    if (!_isPrivateMode && _history.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text('Recent History', style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 8),
                            ..._history.reversed.take(5).map((url) => ListTile(
                              dense: true,
                              title: Text(_extractDomain(url), style: const TextStyle(color: Colors.white)),
                              onTap: () => _loadUrl(url),
                            )),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractDomain(String url) {
    final uri = Uri.tryParse(url);
    return uri?.host.replaceAll('www.', '') ?? url;
  }
}
