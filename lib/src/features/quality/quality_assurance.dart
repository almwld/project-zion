import 'package:flutter/material.dart';

class QualityAssuranceCenter extends StatelessWidget {
  const QualityAssuranceCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Quality Assurance'),
        backgroundColor: Colors.teal.shade900,
      ),
      body: const Center(
        child: Text(
          'Quality Assurance - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
