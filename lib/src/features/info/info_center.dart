import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class InfoCenter extends StatefulWidget {
  const InfoCenter({super.key});

  @override
  State<InfoCenter> createState() => _InfoCenterState();
}

class _InfoCenterState extends State<InfoCenter> {
  String _appVersion = '3.3.0';
  String _buildNumber = '2024.001';
  String _deviceModel = '';
  String _osVersion = '';
  String _kernelVersion = '';
  int _totalRAM = 0;
  int _availableRAM = 0;
  int _totalStorage = 0;
  int _availableStorage = 0;
  String _cpuInfo = '';
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
    
    // معلومات الجهاز
    _deviceModel = Platform.isAndroid ? 'Android Device' : 'iOS Device';
    _osVersion = Platform.operatingSystemVersion;
    
    // معلومات الذاكرة (تقديرية)
    _totalRAM = 4096;
    _availableRAM = 2048;
    _totalStorage = 64;
    _availableStorage = 32;
    _cpuInfo = 'Octa-core 2.4 GHz';
    _batteryLevel = 85;
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareInfo() {
    final info = '''
═══════════════════════════════════════
           ZION OS INFORMATION
═══════════════════════════════════════

📱 Device: $_deviceModel
🤖 OS: $_osVersion
📦 Version: $_appVersion ($_buildNumber)
💻 CPU: $_cpuInfo
🧠 RAM: $_totalRAM MB (${_totalRAM - _availableRAM} MB used)
💾 Storage: $_totalStorage GB (${_totalStorage - _availableStorage} GB used)
🔋 Battery: $_batteryLevel%
═══════════════════════════════════════
''';
    Share.share(info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Info Center'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAboutCard()),
          SliverToBoxAdapter(child: _buildSystemInfoCard()),
          SliverToBoxAdapter(child: _buildResourcesCard()),
          SliverToBoxAdapter(child: _buildLinksCard()),
          SliverToBoxAdapter(child: _buildCreditsCard()),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade900, Colors.purple.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.blue, blurRadius: 20),
              ],
            ),
            child: const Icon(Icons.security, color: Colors.black, size: 45),
          ),
          const SizedBox(height: 16),
          const Text(
            'ZION OS',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4),
          ),
          const SizedBox(height: 4),
          Text(
            'Version $_appVersion ($_buildNumber)',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          const Text(
            'The most advanced mobile penetration testing OS',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _shareInfo,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.update, color: Colors.white),
                onPressed: () => _openLink('https://github.com/almwld/project-zion/releases'),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.star, color: Colors.yellow),
                onPressed: () => _openLink('https://github.com/almwld/project-zion'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.devices, color: Colors.cyan),
              SizedBox(width: 8),
              Text('System Information', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          _buildInfoRow('Device Model', _deviceModel),
          _buildInfoRow('Operating System', _osVersion),
          _buildInfoRow('Kernel Version', _kernelVersion.isEmpty ? 'Linux 5.10' : _kernelVersion),
          _buildInfoRow('CPU', _cpuInfo),
        ],
      ),
    );
  }

  Widget _buildResourcesCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.memory, color: Colors.green),
              SizedBox(width: 8),
              Text('Resources', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          _buildResourceRow('RAM', _totalRAM, _availableRAM),
          _buildResourceRow('Storage', _totalStorage, _availableStorage),
          _buildBatteryRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildResourceRow(String label, int total, int available) {
    final used = total - available;
    final percent = (used / total);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70)),
              Text('$used / $total ${label == 'RAM' ? 'MB' : 'GB'}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey.shade800,
            color: percent > 0.8 ? Colors.red : percent > 0.6 ? Colors.orange : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryRow() {
    final percent = _batteryLevel / 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Battery', style: TextStyle(color: Colors.white70)),
              Text('$_batteryLevel%', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey.shade800,
            color: percent > 0.7 ? Colors.green : percent > 0.3 ? Colors.orange : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildLinksCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.link, color: Colors.orange),
              SizedBox(width: 8),
              Text('Useful Links', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          _buildLinkRow('📖 Documentation', 'https://docs.zion-os.com'),
          _buildLinkRow('💬 Community', 'https://community.zion-os.com'),
          _buildLinkRow('🐛 Report Bug', 'https://github.com/almwld/project-zion/issues'),
          _buildLinkRow('⭐ Star on GitHub', 'https://github.com/almwld/project-zion'),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String title, String url) {
    return ListTile(
      leading: const Icon(Icons.open_in_new, color: Colors.orange),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => _openLink(url),
    );
  }

  Widget _buildCreditsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code, color: Colors.purple),
              SizedBox(width: 8),
              Text('Credits', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Development Team', style: TextStyle(color: Colors.white)),
            subtitle: Text('almwld & Contributors', style: TextStyle(color: Colors.grey)),
          ),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.flutter)),
            title: Text('Powered by', style: TextStyle(color: Colors.white)),
            subtitle: Text('Flutter Framework', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '© 2024 Zion OS. All rights reserved.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
