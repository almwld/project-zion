import 'package:flutter/material.dart';

class BackupRestoreCenter extends StatelessWidget {
  const BackupRestoreCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: const Center(
        child: Text(
          'Backup & Restore - Coming Soon',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
