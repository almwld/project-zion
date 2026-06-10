import 'package:flutter/material.dart';

class MediaCenter extends StatelessWidget {
  const MediaCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Media Center'),
        backgroundColor: Colors.pink.shade900,
      ),
      body: const Center(
        child: Text(
          'Media Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
