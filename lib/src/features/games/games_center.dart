import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GamesCenter extends StatefulWidget {
  const GamesCenter({super.key});

  @override
  State<GamesCenter> createState() => _GamesCenterState();
}

class _GamesCenterState extends State<GamesCenter> {
  String _selectedGame = 'Snake';
  int _score = 0;
  int _highScore = 0;
  bool _isPlaying = false;
  
  // Snake Game
  List<List<int>> _snake = [];
  List<int> _food = [];
  String _direction = 'RIGHT';
  Timer? _gameTimer;

  @override
  void initState() {
    super.initState();
    _initSnake();
  }

  void _initSnake() {
    _snake = [
      [5, 5],
      [5, 4],
      [5, 3],
      [5, 2]
    ];
    _direction = 'RIGHT';
    _generateFood();
    _score = 0;
  }

  void _generateFood() {
    final random = Random();
    do {
      _food = [random.nextInt(15), random.nextInt(15)];
    } while (_snake.any((segment) => segment[0] == _food[0] && segment[1] == _food[1]));
  }

  void _startSnake() {
    if (_isPlaying) return;
    _initSnake();
    _isPlaying = true;
    _gameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _moveSnake();
    });
  }

  void _moveSnake() {
    setState(() {
      final newHead = List<int>.from(_snake.first);
      switch (_direction) {
        case 'RIGHT': newHead[1]++; break;
        case 'LEFT': newHead[1]--; break;
        case 'UP': newHead[0]--; break;
        case 'DOWN': newHead[0]++; break;
      }
      
      _snake.insert(0, newHead);
      
      if (newHead[0] == _food[0] && newHead[1] == _food[1]) {
        _score++;
        if (_score > _highScore) _highScore = _score;
        _generateFood();
      } else {
        _snake.removeLast();
      }
      
      // Check collision
      if (newHead[0] < 0 || newHead[0] >= 15 || newHead[1] < 0 || newHead[1] >= 15 ||
          _snake.skip(1).any((segment) => segment[0] == newHead[0] && segment[1] == newHead[1])) {
        _gameOver();
      }
    });
  }

  void _gameOver() {
    _gameTimer?.cancel();
    _isPlaying = false;
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Games Center'),
        backgroundColor: Colors.amber.shade900,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.games, color: Colors.amber, size: 64),
            const SizedBox(height: 20),
            const Text('Games Center', style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 10),
            Text('Score: $_score', style: const TextStyle(color: Colors.white)),
            Text('High Score: $_highScore', style: const TextStyle(color: Colors.amber)),
            const SizedBox(height: 20),
            if (!_isPlaying)
              ElevatedButton(
                onPressed: _startSnake,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Play Snake'),
              ),
          ],
        ),
      ),
    );
  }
}
