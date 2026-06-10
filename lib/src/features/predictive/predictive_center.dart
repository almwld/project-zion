import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class PredictiveCenter extends StatefulWidget {
  const PredictiveCenter({super.key});

  @override
  State<PredictiveCenter> createState() => _PredictiveCenterState();
}

class _PredictiveCenterState extends State<PredictiveCenter> {
  int _selectedTab = 0;
  
  // Attack Prediction
  List<PredictedAttack> _predictedAttacks = [];
  double _overallRisk = 0.65;
  List<double> _riskHistory = [];
  Timer? _predictionTimer;
  
  // ML Model Training
  bool _isTraining = false;
  double _trainingProgress = 0;
  String _modelAccuracy = '94.5%';
  List<TrainingMetric> _trainingMetrics = [];
  
  // Anomaly Detection
  List<AnomalyScore> _anomalyScores = [];
  double _threshold = 0.7;
  bool _autoAdjust = true;
  
  // Recommendation Engine
  List<SecurityRecommendation> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _initPredictionData();
    _initTrainingMetrics();
    _initAnomalyData();
    _initRecommendations();
    _startPredictions();
    _initRiskHistory();
  }

  void _initRiskHistory() {
    for (int i = 0; i < 20; i++) {
      _riskHistory.add(0.3 + Random().nextDouble() * 0.5);
    }
  }

  void _initPredictionData() {
    _predictedAttacks = [
      PredictedAttack('DDoS Attack', '10.0.0.0/24', 0.85, 'High', DateTime.now().add(const Duration(hours: 2))),
      PredictedAttack('Port Scan', '192.168.1.0/24', 0.72, 'Medium', DateTime.now().add(const Duration(hours: 4))),
      PredictedAttack('Brute Force', '192.168.1.105', 0.68, 'Medium', DateTime.now().add(const Duration(hours: 6))),
      PredictedAttack('Malware Injection', '10.0.0.25', 0.45, 'Low', DateTime.now().add(const Duration(hours: 12))),
    ];
  }

  void _initTrainingMetrics() {
    _trainingMetrics = [
      TrainingMetric('Epoch 1', 0.65, 0.72, 85.3),
      TrainingMetric('Epoch 2', 0.72, 0.78, 88.1),
      TrainingMetric('Epoch 3', 0.78, 0.83, 90.2),
      TrainingMetric('Epoch 4', 0.83, 0.87, 92.5),
      TrainingMetric('Epoch 5', 0.87, 0.90, 94.5),
    ];
  }

  void _initAnomalyData() {
    _anomalyScores = [
      AnomalyScore('HTTP Traffic Spike', 0.92, DateTime.now().subtract(const Duration(minutes: 5))),
      AnomalyScore('Failed Logins', 0.88, DateTime.now().subtract(const Duration(minutes: 12))),
      AnomalyScore('Unusual Outbound Traffic', 0.76, DateTime.now().subtract(const Duration(minutes: 25))),
      AnomalyScore('Process Injection', 0.65, DateTime.now().subtract(const Duration(minutes: 45))),
      AnomalyScore('Registry Changes', 0.58, DateTime.now().subtract(const Duration(hours: 1))),
    ];
  }

  void _initRecommendations() {
    _recommendations = [
      SecurityRecommendation('Block Suspicious IP Range', 'High priority: Block 10.0.0.0/24 to prevent DDoS', 0.92, 'Action Required'),
      SecurityRecommendation('Update Firewall Rules', 'Add rate limiting for port 443', 0.85, 'Recommended'),
      SecurityRecommendation('Patch Vulnerability', 'CVE-2024-1234 affects your system', 0.78, 'Important'),
      SecurityRecommendation('Enable 2FA', 'Enable two-factor authentication for admin accounts', 0.72, 'Optional'),
    ];
  }

  void _startPredictions() {
    _predictionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final random = Random();
      setState(() {
        _overallRisk = 0.3 + random.nextDouble() * 0.6;
        _riskHistory.add(_overallRisk);
        if (_riskHistory.length > 20) _riskHistory.removeAt(0);
        
        for (var attack in _predictedAttacks) {
          attack.probability = (attack.probability + (random.nextDouble() - 0.5) * 0.05).clamp(0.0, 1.0);
        }
        _predictedAttacks.sort((a, b) => b.probability.compareTo(a.probability));
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
        _modelAccuracy = '${85 + (i * 0.1).toInt()}%';
      });
    }

    setState(() {
      _isTraining = false;
      _modelAccuracy = '96.2%';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Model training completed! Accuracy: 96.2%')),
    );
  }

  void _applyRecommendation(SecurityRecommendation rec) {
    setState(() {
      rec.status = 'Applied';
      _recommendations.remove(rec);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Applied: ${rec.title}')),
    );
  }

  Color _getRiskColor(double risk) {
    if (risk >= 0.7) return Colors.red;
    if (risk >= 0.4) return Colors.orange;
    return Colors.green;
  }

  Color _getProbabilityColor(double prob) {
    if (prob >= 0.7) return Colors.red;
    if (prob >= 0.5) return Colors.orange;
    return Colors.yellow;
  }

  @override
  void dispose() {
    _predictionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Predictive Analytics'),
        backgroundColor: Colors.indigo.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.warning), text: 'Predictions'),
            Tab(icon: Icon(Icons.model_training), text: 'ML Training'),
            Tab(icon: Icon(Icons.analytics), text: 'Anomalies'),
            Tab(icon: Icon(Icons.recommend), text: 'Recommendations'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildPredictionsTab(),
          _buildMLTrainingTab(),
          _buildAnomalyTab(),
          _buildRecommendationsTab(),
        ],
      ),
    );
  }

  Widget _buildPredictionsTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Overall Risk Score', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: _overallRisk,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade800,
                      color: _getRiskColor(_overallRisk),
                    ),
                  ),
                  Column(
                    children: [
                      Text('${(_overallRisk * 100).toInt()}%', style: TextStyle(color: _getRiskColor(_overallRisk), fontSize: 32, fontWeight: FontWeight.bold)),
                      const Text('Risk Level', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _riskHistory.length,
                  itemBuilder: (ctx, i) => Container(
                    width: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: _riskHistory[i] * 100,
                    color: _getRiskColor(_riskHistory[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _predictedAttacks.length,
            itemBuilder: (ctx, i) {
              final attack = _predictedAttacks[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: _getProbabilityColor(attack.probability), width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(attack.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getProbabilityColor(attack.probability).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(attack.severity, style: TextStyle(color: _getProbabilityColor(attack.probability))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Target: ${attack.target}', style: const TextStyle(color: Colors.grey)),
                    Text('Expected: ${_formatTime(attack.expectedTime)}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: attack.probability,
                      backgroundColor: Colors.grey.shade800,
                      color: _getProbabilityColor(attack.probability),
                    ),
                    Text('Probability: ${(attack.probability * 100).toInt()}%', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMLTrainingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.model_training, size: 48, color: Colors.indigo),
                const SizedBox(height: 12),
                Text('Model Accuracy: $_modelAccuracy', style: const TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 16),
                if (_isTraining) ...[
                  LinearProgressIndicator(value: _trainingProgress),
                  const SizedBox(height: 8),
                  Text('Training: ${(_trainingProgress * 100).toInt()}%', style: const TextStyle(color: Colors.white70)),
                ] else
                  ElevatedButton(
                    onPressed: _trainModel,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    child: const Text('START TRAINING'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Training History', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                DataTable(
                  columnSpacing: 16,
                  columns: const [
                    DataColumn(label: Text('Epoch', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Loss', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Accuracy', style: TextStyle(color: Colors.white))),
                  ],
                  rows: _trainingMetrics.map((m) => DataRow(cells: [
                    DataCell(Text(m.epoch, style: const TextStyle(color: Colors.white))),
                    DataCell(Text('${m.loss.toStringAsFixed(3)}', style: const TextStyle(color: Colors.white))),
                    DataCell(Text('${m.accuracy.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.green))),
                  ])).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnomalyTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('Detection Threshold:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: _threshold,
                  onChanged: (v) => setState(() => _threshold = v),
                ),
              ),
              Text('${(_threshold * 100).toInt()}%', style: const TextStyle(color: Colors.orange)),
              Switch(
                value: _autoAdjust,
                onChanged: (v) => setState(() => _autoAdjust = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _anomalyScores.length,
            itemBuilder: (ctx, i) {
              final anomaly = _anomalyScores[i];
              final isAnomaly = anomaly.score >= _threshold;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isAnomaly ? Colors.red : Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(isAnomaly ? Icons.warning : Icons.check_circle, color: isAnomaly ? Colors.red : Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(anomaly.name, style: const TextStyle(color: Colors.white)),
                          Text('Score: ${(anomaly.score * 100).toInt()}%', style: TextStyle(color: isAnomaly ? Colors.red : Colors.white70)),
                        ],
                      ),
                    ),
                    Text(_formatTime(anomaly.time), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsTab() {
    return ListView.builder(
      itemCount: _recommendations.length,
      itemBuilder: (ctx, i) {
        final rec = _recommendations[i];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: rec.priority == 'High priority' ? Colors.red : Colors.orange, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(rec.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: rec.priority == 'High priority' ? Colors.red.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(rec.status, style: TextStyle(color: rec.priority == 'High priority' ? Colors.red : Colors.orange, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(rec.description, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                children: [
                  LinearProgressIndicator(
                    value: rec.confidence,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.blue,
                    expanded: true,
                  ),
                  const SizedBox(width: 8),
                  Text('${(rec.confidence * 100).toInt()}%', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: rec.status == 'Applied' ? null : () => _applyRecommendation(rec),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

class PredictedAttack {
  final String name;
  final String target;
  double probability;
  final String severity;
  final DateTime expectedTime;

  PredictedAttack(this.name, this.target, this.probability, this.severity, this.expectedTime);
}

class TrainingMetric {
  final String epoch;
  final double loss;
  final double validationLoss;
  final double accuracy;

  TrainingMetric(this.epoch, this.loss, this.validationLoss, this.accuracy);
}

class AnomalyScore {
  final String name;
  final double score;
  final DateTime time;

  AnomalyScore(this.name, this.score, this.time);
}

class SecurityRecommendation {
  final String title;
  final String description;
  final double confidence;
  String status;
  final String priority;

  SecurityRecommendation(this.title, this.description, this.confidence, this.priority, [this.status = 'Pending']);
}
