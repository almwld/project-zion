import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  // تأخير بسيط لتجنب مشاكل LG
  runZonedGuarded(() {
    runApp(const ZionOS());
  }, (error, stack) {
    print('Error: $error');
  });
}

class ZionOS extends StatelessWidget {
  const ZionOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zion OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ZionHomePage(),
    );
  }
}

class ZionHomePage extends StatefulWidget {
  const ZionHomePage({super.key});

  @override
  State<ZionHomePage> createState() => _ZionHomePageState();
}

class _ZionHomePageState extends State<ZionHomePage> {
  @override
  void initState() {
    super.initState();
    // تأخير إضافي لـ LG
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'ZION OS',
              style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Loading for LG device...',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
