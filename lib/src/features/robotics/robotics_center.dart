import 'package:flutter/material.dart';

class RoboticsCenter extends StatelessWidget {
  const RoboticsCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Robotics Center'),
        backgroundColor: Colors.cyan.shade900,
      ),
      body: const Center(
        child: Text(
          'Robotics Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
