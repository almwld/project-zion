import 'package:flutter/material.dart';

class PredictiveCenter extends StatelessWidget {
  const PredictiveCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Predictive Analytics'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: const Center(
        child: Text(
          'Predictive Analytics - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
