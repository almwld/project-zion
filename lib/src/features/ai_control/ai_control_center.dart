import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AIControlCenter extends StatefulWidget {
  const AIControlCenter({super.key});

  @override
  State<AIControlCenter> createState() => _AIControlCenterState();
}

class _AIControlCenterState extends State<AIControlCenter> {
  int _selectedTab = 0;
  
  // AI Models
  List<AIModel> _models = [];
  bool _isTraining = false;
  double _trainingProgress = 0;
  String _selectedModel = 'SI Agent';
  
  // Neural Network Visualization
  List<NeuronLayer> _networkLayers = [];
  double _neuralActivity = 0;
  Timer? _neuralTimer;
  
  // AI Predictions
  List<AIPrediction> _predictions = [];
  double _confidenceScore = 0;
  
  // Training Data
  List<TrainingData> _trainingData = [];
  int _totalSamples = 0;
  double _accuracy = 0;

  @override
  void initState() {
    super.initState();
    _loadModels();
    _initNeuralNetwork();
    _loadPredictions();
    _loadTrainingData();
    _startNeuralAnimation();
  }

  void _loadModels() {
    _models = [
      AIModel('SI Agent', 'Sentient Intelligence', 'Active', 94.5, Icons.psychology, Colors.purple),
      AIModel('Threat Detector', 'Anomaly Detection', 'Active', 91.2, Icons.warning, Colors.red),
      AIModel('Predictor', 'Attack Prediction', 'Training', 87.3, Icons.trending_up, Colors.cyan),
      AIModel('Optimizer', 'Performance Tuning', 'Inactive', 0, Icons.speed, Colors.green),
    ];
  }

  void _initNeuralNetwork() {
    _networkLayers = [
      NeuronLayer(5, 0.3),
      NeuronLayer(8, 0.5),
      NeuronLayer(12, 0.7),
      NeuronLayer(8, 0.6),
      NeuronLayer(4, 0.4),
    ];
  }

  void _loadPredictions() {
    _predictions = [
      AIPrediction('Attack Probability', 0.72, 'High', DateTime.now().add(const Duration(hours: 2))),
      AIPrediction('System Load', 0.45, 'Medium', DateTime.now().add(const Duration(hours: 4))),
      AIPrediction('Memory Usage', 0.68, 'High', DateTime.now().add(const Duration(hours: 6))),
      AIPrediction('Network Anomaly', 0.23, 'Low', DateTime.now().add(const Duration(hours: 8))),
    ];
    _confidenceScore = 0.85;
  }

  void _loadTrainingData() {
    _trainingData = [
      TrainingData('Network Traffic', 12500, 96.5),
      TrainingData('Attack Vectors', 8900, 94.2),
      TrainingData('System Logs', 15600, 92.8),
      TrainingData('User Behavior', 7200, 95.1),
    ];
    _totalSamples = 12500 + 8900 + 15600 + 7200;
    _accuracy = 94.5;
  }

  void _startNeuralAnimation() {
    _neuralTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final random = Random();
      setState(() {
        _neuralActivity = random.nextDouble();
        for (var layer in _networkLayers) {
          layer.activity = (layer.activity + (random.nextDouble() - 0.5) * 0.2).clamp(0.0, 1.0);
        }
      });
    });
  }

  void _trainModel() async {
    setState(() {
      _isTraining = true;
      _trainingProgress = 0;
    });

    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _trainingProgress = i / 100;
        _accuracy = 85 + (i * 0.12);
      });
    }

    setState(() {
      _isTraining = false;
      _models[2].status = 'Active';
      _models[2].accuracy = _accuracy;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Model training completed! Accuracy: ${_accuracy.toStringAsFixed(1)}%')),
    );
  }

  @override
  void dispose() {
    _neuralTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AI Control Center'),
        backgroundColor: Colors.cyan.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.psychology), text: 'Models'),
            Tab(icon: Icon(Icons.bubble_chart), text: 'Neural Net'),
            Tab(icon: Icon(Icons.trending_up), text: 'Predictions'),
            Tab(icon: Icon(Icons.data_usage), text: 'Training'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildModelsTab(),
          _buildNeuralNetTab(),
          _buildPredictionsTab(),
          _buildTrainingTab(),
        ],
      ),
    );
  }

  Widget _buildModelsTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildModelStat('Active Models', '${_models.where((m) => m.status == 'Active').length}', Colors.green),
              _buildModelStat('Avg Accuracy', '${_models.map((m) => m.accuracy).reduce((a, b) => a + b) / _models.length}%', Colors.cyan),
              _buildModelStat('Total Training', '$_totalSamples', Colors.purple),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _models.length,
            itemBuilder: (ctx, i) {
              final model = _models[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: model.color, width: 4)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: model.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(model.icon, color: model.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text(model.description, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: model.status == 'Active' ? Colors.green.withOpacity(0.2) : 
                                   model.status == 'Training' ? Colors.orange.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(model.status, style: TextStyle(color: model.status == 'Active' ? Colors.green : Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: model.accuracy / 100,
                      backgroundColor: Colors.grey.shade800,
                      color: model.color,
                    ),
                    const SizedBox(height: 4),
                    Text('Accuracy: ${model.accuracy}%', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModelStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildNeuralNetTab() {
    return Column(
      children: [
        // Neural Network Visualization
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomPaint(
              painter: NeuralNetworkPainter(_networkLayers, _neuralActivity),
              size: Size.infinite,
            ),
          ),
        ),
        
        // Neural Activity
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('Neural Network Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _neuralActivity,
                backgroundColor: Colors.grey.shade800,
                color: Colors.cyan,
              ),
              const SizedBox(height: 4),
              Text('${(_neuralActivity * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.cyan)),
            ],
          ),
        ),
        
        // Layer Details
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: _networkLayers.length,
            itemBuilder: (ctx, i) {
              final layer = _networkLayers[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('Layer ${i + 1}', style: const TextStyle(color: Colors.white)),
                    const Spacer(),
                    Text('${layer.neurons} neurons', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 16),
                    LinearProgressIndicator(
                      value: layer.activity,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.purple,
                      
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionsTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.cyan.shade900, Colors.purple.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Overall Confidence', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _confidenceScore,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.white,
                    ),
                  ),
                  Text('${(_confidenceScore * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _predictions.length,
            itemBuilder: (ctx, i) {
              final pred = _predictions[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: pred.severity == 'High' ? Colors.red : pred.severity == 'Medium' ? Colors.orange : Colors.green, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(pred.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('${(pred.probability * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.cyan)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: pred.probability,
                      backgroundColor: Colors.grey.shade800,
                      color: pred.severity == 'High' ? Colors.red : pred.severity == 'Medium' ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(height: 4),
                    Text('Expected: ${_formatTime(pred.expectedTime)}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('Training Progress', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),
              if (_isTraining) ...[
                LinearProgressIndicator(value: _trainingProgress),
                const SizedBox(height: 8),
                Text('${(_trainingProgress * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.cyan)),
              ] else
                ElevatedButton(
                  onPressed: _trainModel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: const Text('START TRAINING'),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _trainingData.length,
            itemBuilder: (ctx, i) {
              final data = _trainingData[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(data.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('${data.accuracy}%', style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Samples: ${data.samples}', style: const TextStyle(color: Colors.grey)),
                    LinearProgressIndicator(
                      value: data.accuracy / 100,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.cyan,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = time.difference(DateTime.now());
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return '${diff.inSeconds}s';
  }
}

class AIModel {
  final String name;
  final String description;
  String status;
  double accuracy;
  final IconData icon;
  final Color color;

  AIModel(this.name, this.description, this.status, this.accuracy, this.icon, this.color);
}

class NeuronLayer {
  final int neurons;
  double activity;

  NeuronLayer(this.neurons, this.activity);
}

class AIPrediction {
  final String name;
  final double probability;
  final String severity;
  final DateTime expectedTime;

  AIPrediction(this.name, this.probability, this.severity, this.expectedTime);
}

class TrainingData {
  final String name;
  final int samples;
  final double accuracy;

  TrainingData(this.name, this.samples, this.accuracy);
}

class NeuralNetworkPainter extends CustomPainter {
  final List<NeuronLayer> layers;
  final double activity;

  NeuralNetworkPainter(this.layers, this.activity);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final layerSpacing = width / (layers.length + 1);
    
    for (int i = 0; i < layers.length; i++) {
      final x = (i + 1) * layerSpacing;
      final neurons = layers[i].neurons;
      final neuronSpacing = height / (neurons + 1);
      
      for (int j = 0; j < neurons; j++) {
        final y = (j + 1) * neuronSpacing;
        final intensity = layers[i].activity * activity;
        final paint = Paint()
          ..color = Colors.cyan.withOpacity(0.3 + intensity * 0.7)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 8, paint);
        
        // Draw connections to next layer
        if (i < layers.length - 1) {
          final nextX = (i + 2) * layerSpacing;
          final nextNeurons = layers[i + 1].neurons;
          final nextSpacing = height / (nextNeurons + 1);
          
          for (int k = 0; k < nextNeurons; k++) {
            final nextY = (k + 1) * nextSpacing;
            final linePaint = Paint()
              ..color = Colors.cyan.withOpacity(0.1 + intensity * 0.3)
              ..strokeWidth = 1;
            canvas.drawLine(Offset(x, y), Offset(nextX, nextY), linePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
