import 'package:flutter/material.dart';

class SecurityCenter extends StatefulWidget {
  const SecurityCenter({super.key});

  @override
  State<SecurityCenter> createState() => _SecurityCenterState();
}

class _SecurityCenterState extends State<SecurityCenter> {
  int _securityScore = 85;
  bool _stealthMode = false;

  void _toggleStealthMode() {
    setState(() {
      _stealthMode = !_stealthMode;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_stealthMode ? 'Stealth Mode ON' : 'Stealth Mode OFF')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Security Center'),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Security Score Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red.shade900, Colors.black],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Security Score', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: _securityScore / 100,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade800,
                          color: Colors.green,
                        ),
                      ),
                      Text('$_securityScore%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Security Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Stealth Mode', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Hide app activities', style: TextStyle(color: Colors.grey)),
                    secondary: const Icon(Icons.visibility_off, color: Colors.purple),
                    value: _stealthMode,
                    onChanged: (_) => _toggleStealthMode(),
                    activeColor: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
