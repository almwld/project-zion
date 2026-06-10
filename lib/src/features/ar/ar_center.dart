import 'package:flutter/material.dart';

class ARCenter extends StatelessWidget {
  const ARCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AR & Visualization Center'),
        backgroundColor: Colors.purple.shade900,
      ),
      body: const Center(
        child: Text(
          'AR Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
