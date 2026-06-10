import 'package:flutter/material.dart';

class LearningCenter extends StatefulWidget {
  const LearningCenter({super.key});

  @override
  State<LearningCenter> createState() => _LearningCenterState();
}

class _LearningCenterState extends State<LearningCenter> {
  int _userLevel = 1;
  int _userXP = 45;
  int _nextLevelXP = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Learning Center'),
        backgroundColor: Colors.teal.shade900,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_userLevel',
                  style: const TextStyle(color: Colors.teal, fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Level $_userLevel',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '$_userXP / $_nextLevelXP XP',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _userXP / _nextLevelXP,
              backgroundColor: Colors.grey.shade800,
              color: Colors.teal,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
