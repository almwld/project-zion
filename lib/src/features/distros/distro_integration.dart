import 'package:flutter/material.dart';

class DistroIntegration extends StatelessWidget {
  const DistroIntegration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Linux Distros'), backgroundColor: Colors.indigo.shade900),
      body: const Center(child: Text('Distro Integration - Coming Soon', style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}
