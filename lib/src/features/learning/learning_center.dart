import 'package:flutter/material.dart';

class LearningCenter extends StatelessWidget {
  const LearningCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Learning Center'),
        backgroundColor: Colors.teal.shade900,
      ),
      body: const Center(
        child: Text(
          'Learning Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
