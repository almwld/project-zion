import 'package:flutter/material.dart';

class EnergyCenter extends StatelessWidget {
  const EnergyCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Energy Center'),
        backgroundColor: Colors.green.shade900,
      ),
      body: const Center(
        child: Text(
          'Energy Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
