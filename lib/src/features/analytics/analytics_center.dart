import 'package:flutter/material.dart';

class AnalyticsCenter extends StatelessWidget {
  const AnalyticsCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Analytics Center'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: const Center(
        child: Text(
          'Analytics Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
