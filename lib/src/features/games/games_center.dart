import 'package:flutter/material.dart';

class GamesCenter extends StatelessWidget {
  const GamesCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Games Center'),
        backgroundColor: Colors.amber.shade900,
      ),
      body: const Center(
        child: Text(
          'Games Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
