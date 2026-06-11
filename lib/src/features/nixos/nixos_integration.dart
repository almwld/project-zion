import 'package:flutter/material.dart';

class NixOSIntegration extends StatelessWidget {
  const NixOSIntegration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('NixOS Integration'), backgroundColor: Colors.blueGrey.shade900),
      body: const Center(child: Text('NixOS Integration - Coming Soon', style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }
}
