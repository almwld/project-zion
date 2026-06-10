import 'package:flutter/material.dart';

class ContainerManager extends StatelessWidget {
  const ContainerManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Container Manager'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: const Center(
        child: Text(
          'Container Manager - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
