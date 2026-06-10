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
  
  // TicTacToe
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _winner = '';
  
  // Memory Game
  List<int> _memoryCards = [];
  List<bool> _memoryFlipped = [];
  List<bool> _memoryMatched = [];
  int _flippedIndex = -1;
  int _matchesFound = 0;
  
  // Pong Game
  double _paddleY = 0;
  double _ballX = 0;
  double _ballY = 0;
  double _ballVelX = 0;
  double _ballVelY = 0;
  int _playerScore = 0;
  int _aiScore = 0;

  @override
  void initState() {
    super.initState();
    _initSnake();
    _initMemoryGame();
    _initPong();
  }

  // ==================== Snake Game ====================
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
      final newHead = List.from(_snake.first);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game Over! Score: $_score')),
    );
  }

  // ==================== TicTacToe ====================
  void _resetTicTacToe() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _winner = '';
    });
  }

  void _makeMove(int index) {
    if (_board[index] != '' || _winner != '') return;
    
    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      _checkWinner();
      _isXTurn = !_isXTurn;
    });
  }

  void _checkWinner() {
    const winPatterns = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ];
    
    for (final pattern in winPatterns) {
      if (_board[pattern[0]] != '' &&
          _board[pattern[0]] == _board[pattern[1]] &&
          _board[pattern[1]] == _board[pattern[2]]) {
        _winner = _board[pattern[0]];
        break;
      }
    }
    
    if (_winner != '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Player $_winner wins!')),
      );
    } else if (!_board.contains('')) {
      _winner = 'Draw';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game Draw!')),
      );
    }
  }

  // ==================== Memory Game ====================
  void _initMemoryGame() {
    _memoryCards = List.generate(8, (i) => i)..addAll(List.generate(8, (i) => i));
    _memoryCards.shuffle();
    _memoryFlipped = List.filled(16, false);
    _memoryMatched = List.filled(16, false);
    _matchesFound = 0;
  }

  void _flipCard(int index) {
    if (_memoryMatched[index] || _memoryFlipped[index]) return;
    
    setState(() {
      _memoryFlipped[index] = true;
      
      if (_flippedIndex == -1) {
        _flippedIndex = index;
      } else {
        if (_memoryCards[_flippedIndex] == _memoryCards[index]) {
          _memoryMatched[_flippedIndex] = true;
          _memoryMatched[index] = true;
          _matchesFound++;
          _flippedIndex = -1;
          
          if (_matchesFound == 8) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Congratulations! You won!')),
            );
          }
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _memoryFlipped[_flippedIndex] = false;
              _memoryFlipped[index] = false;
              _flippedIndex = -1;
            });
          });
        }
        _flippedIndex = -1;
      }
    });
  }

  void _resetMemoryGame() {
    _initMemoryGame();
    _flippedIndex = -1;
    setState(() {});
  }

  // ==================== Pong Game ====================
  void _initPong() {
    _paddleY = 250;
    _ballX = 400;
    _ballY = 250;
    _ballVelX = 3;
    _ballVelY = 2;
    _playerScore = 0;
    _aiScore = 0;
  }

  void _startPong() {
    if (_isPlaying) return;
    _isPlaying = true;
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updatePong();
    });
  }

  void _updatePong() {
    setState(() {
      _ballX += _ballVelX;
      _ballY += _ballVelY;
      
      if (_ballY <= 0 || _ballY >= 500) _ballVelY = -_ballVelY;
      
      // Paddle collision
      if (_ballX <= 50 && _ballY >= _paddleY && _ballY <= _paddleY + 80) {
        _ballVelX = -_ballVelX;
      }
      
      if (_ballX >= 750 && _ballY >= _aiPaddleY && _ballY <= _aiPaddleY + 80) {
        _ballVelX = -_ballVelX;
      }
      
      if (_ballX <= 0) {
        _aiScore++;
        _resetBall();
      }
      
      if (_ballX >= 800) {
        _playerScore++;
        _resetBall();
      }
    });
  }

  double get _aiPaddleY => _ballY - 40;
  
  void _resetBall() {
    _ballX = 400;
    _ballY = 250;
    _ballVelX = _ballVelX > 0 ? -3 : 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Games Center'),
        backgroundColor: Colors.amber.shade900,
      ),
      body: Column(
        children: [
          _buildGameSelector(),
          Expanded(
            child: IndexedStack(
              index: _getGameIndex(),
              children: [
                _buildSnakeGame(),
                _buildTicTacToe(),
                _buildMemoryGame(),
                _buildPongGame(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSelector() {
    final games = ['Snake', 'TicTacToe', 'Memory', 'Pong'];
    return Container(
      height: 50,
      color: Colors.grey.shade900,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () => setState(() => _selectedGame = games[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _selectedGame == games[i] ? Colors.amber : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Center(
              child: Text(
                games[i],
                style: TextStyle(
                  color: _selectedGame == games[i] ? Colors.amber : Colors.white70,
                  fontWeight: _selectedGame == games[i] ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getGameIndex() {
    switch (_selectedGame) {
      case 'Snake': return 0;
      case 'TicTacToe': return 1;
      case 'Memory': return 2;
      case 'Pong': return 3;
      default: return 0;
    }
  }

  Widget _buildSnakeGame() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Score: $_score', style: const TextStyle(color: Colors.white, fontSize: 18)),
              Text('High Score: $_highScore', style: const TextStyle(color: Colors.amber, fontSize: 18)),
              if (!_isPlaying)
                ElevatedButton(
                  onPressed: _startSnake,
                  child: const Text('Start Game'),
                ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx.abs() > details.delta.dy.abs()) {
                setState(() => _direction = details.delta.dx > 0 ? 'RIGHT' : 'LEFT');
              } else {
                setState(() => _direction = details.delta.dy > 0 ? 'DOWN' : 'UP');
              }
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 15,
                ),
                itemCount: 225,
                itemBuilder: (ctx, i) {
                  final row = i ~/ 15;
                  final col = i % 15;
                  final isSnake = _snake.any((s) => s[0] == row && s[1] == col);
                  final isFood = _food[0] == row && _food[1] == col;
                  return Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSnake ? Colors.green : (isFood ? Colors.red : Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicTacToe() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _winner != '' ? 'Winner: $_winner' : 'Turn: ${_isXTurn ? 'X' : 'O'}',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => _makeMove(i),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _board[i],
                      style: const TextStyle(color: Colors.white, fontSize: 48),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetTicTacToe,
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryGame() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Matches: $_matchesFound / 8', style: const TextStyle(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 20),
          Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: 16,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => _flipCard(i),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _memoryMatched[i] ? Colors.green :
                           _memoryFlipped[i] ? Colors.blue : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _memoryFlipped[i] || _memoryMatched[i] ? '${_memoryCards[i] + 1}' : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetMemoryGame,
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  Widget _buildPongGame() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Player: $_playerScore', style: const TextStyle(color: Colors.white, fontSize: 24)),
              Text('AI: $_aiScore', style: const TextStyle(color: Colors.amber, fontSize: 24)),
              if (!_isPlaying)
                ElevatedButton(
                  onPressed: _startPong,
                  child: const Text('Start Game'),
                ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _paddleY += details.delta.dy;
                _paddleY = _paddleY.clamp(0.0, 420.0);
              });
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomPaint(
                painter: PongPainter(_paddleY, _aiPaddleY, _ballX, _ballY),
                size: const Size(800, 500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PongPainter extends CustomPainter {
  final double paddleY;
  final double aiPaddleY;
  final double ballX;
  final double ballY;
  
  PongPainter(this.paddleY, this.aiPaddleY, this.ballX, this.ballY);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    
    // Player paddle
    canvas.drawRect(Rect.fromLTWH(20, paddleY, 10, 80), paint);
    
    // AI paddle
    canvas.drawRect(Rect.fromLTWH(size.width - 30, aiPaddleY, 10, 80), paint);
    
    // Ball
    canvas.drawCircle(Offset(ballX, ballY), 8, paint);
    
    // Center line
    for (var i = 0; i < size.height; i += 20) {
      canvas.drawRect(Rect.fromLTWH(size.width / 2 - 2, i, 4, 10), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
