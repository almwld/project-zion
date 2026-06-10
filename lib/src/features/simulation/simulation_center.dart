import 'package:flutter/material.dart';

class SimulationCenter extends StatelessWidget {
  const SimulationCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Simulation Center'),
        backgroundColor: Colors.cyan.shade900,
      ),
      body: const Center(
        child: Text(
          'Simulation Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
