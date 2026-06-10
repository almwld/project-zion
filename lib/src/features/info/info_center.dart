import 'package:flutter/material.dart';

class InfoCenter extends StatelessWidget {
  const InfoCenter({super.key});

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
            const Text('Zion OS', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Version 3.3.0', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            const Text('© 2024 Zion OS', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
