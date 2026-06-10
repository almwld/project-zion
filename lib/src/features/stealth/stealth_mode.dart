import 'package:flutter/material.dart';

class StealthMode extends StatelessWidget {
  const StealthMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Stealth Mode'), backgroundColor: Colors.grey.shade900),
      body: const Center(child: Text('Stealth Mode - Coming Soon', style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}
