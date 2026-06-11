import 'package:flutter/material.dart';

class EncryptionCenter extends StatelessWidget {
  const EncryptionCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Encryption Center'),
        backgroundColor: Colors.teal.shade900,
      ),
      body: const Center(
        child: Text(
          'Encryption Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
