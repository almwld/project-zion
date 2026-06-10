import 'package:flutter/material.dart';

class GeospatialCenter extends StatelessWidget {
  const GeospatialCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Geospatial Center'),
        backgroundColor: Colors.green.shade900,
      ),
      body: const Center(
        child: Text(
          'Geospatial Center - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
