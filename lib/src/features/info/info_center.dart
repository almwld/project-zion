import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoCenter extends StatefulWidget {
  const InfoCenter({super.key});

  @override
  State<InfoCenter> createState() => _InfoCenterState();
}

class _InfoCenterState extends State<InfoCenter> {
  String _appVersion = '3.3.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Info Center'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info, color: Colors.blue, size: 64),
            const SizedBox(height: 20),
            Text('Zion OS', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Version $_appVersion', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            const Text('© 2024 Zion OS', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
