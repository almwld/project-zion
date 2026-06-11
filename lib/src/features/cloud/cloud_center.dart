import 'package:flutter/material.dart';

class CloudCenter extends StatelessWidget {
  const CloudCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cloud Center'),
        backgroundColor: Colors.lightBlue.shade900,
      ),
      body: const Center(
        child: Text(
          'Cloud Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
