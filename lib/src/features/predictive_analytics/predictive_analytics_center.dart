import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class PredictiveAnalyticsCenter extends StatefulWidget {
  const PredictiveAnalyticsCenter({super.key});

  @override
  State<PredictiveAnalyticsCenter> createState() => _PredictiveAnalyticsCenterState();
}

class _PredictiveAnalyticsCenterState extends State<PredictiveAnalyticsCenter> {
  int _selectedTab = 0;
  
  // Time Series Forecast
  List<TimeSeriesData> _historicalData = [];
  List<TimeSeriesData> _forecastData = [];
  double _forecastAccuracy = 0;
  
  // Anomaly Detection
  List<Anomaly> _anomalies = [];
  double _anomalyThreshold = 0.85;
  bool _isMonitoring = false;
  
  // Trend Analysis
  List<Trend> _trends = [];
  Map<String, double> _trendStrengths = {};
  
  // Prediction Models
  List<PredictionModel> _models = [];
  String _selectedModel = 'Prophet';
  double _currentPrediction = 0;
  double _confidenceInterval = 0;

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
    _loadModels();
    _loadTrends();
    _startPredictionSimulation();
  }

  void _loadHistoricalData() {
    final random = Random();
    for (int i = 0; i < 30; i++) {
      _historicalData.add(TimeSeriesData(
        DateTime.now().subtract(Duration(days: 29 - i)),
        50 + random.nextDouble() * 50,
      ));
    }
    _generateForecast();
  }

  void _generateForecast() {
    final lastValue = _historicalData.last.value;
    for (int i = 1; i <= 10; i++) {
      final predicted = lastValue + (i * 1.5) + (Random().nextDouble() * 5 - 2.5);
      _forecastData.add(TimeSeriesData(
        DateTime.now().add(Duration(days: i)),
        predicted.clamp(0, 100),
      ));
    }
    _forecastAccuracy = 85 + Random().nextDouble() * 10;
  }

  void _loadModels() {
    _models = [
      PredictionModel('Prophet', 'Facebook', 94.5, Icons.timeline, Colors.blue),
      PredictionModel('ARIMA', 'StatsModels', 92.3, Icons.show_chart, Colors.green),
      PredictionModel('LSTM', 'Deep Learning', 96.8, Icons.psychology, Colors.purple),
      PredictionModel('Random Forest', 'Ensemble', 91.2, Icons.tree, Colors.orange),
    ];
  }

  void _loadTrends() {
    _trends = [
      Trend('CPU Usage', 'up', 15.5, Colors.cyan),
      Trend('Memory Usage', 'up', 8.2, Colors.green),
      Trend('Network Traffic', 'down', -5.3, Colors.orange),
      Trend('Storage', 'stable', 0.5, Colors.grey),
    ];
    
    _trendStrengths = {
      'CPU': 0.75,
      'Memory': 0.62,
      'Network': 0.48,
      'Storage': 0.31,
    };
  }

  void _startPredictionSimulation() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentPrediction = 40 + random.nextDouble() * 40;
          _confidenceInterval = 5 + random.nextDouble() * 10;
          
          // تحديث التنبؤات
          for (int i = 0; i < _forecastData.length; i++) {
            _forecastData[i].value = (_forecastData[i].value + (random.nextDouble() - 0.5) * 2).clamp(0, 100);
          }
        });
      }
    });
  }

  void _detectAnomalies() {
    final random = Random();
    if (random.nextDouble() > 0.7) {
      setState(() {
        _anomalies.insert(0, Anomaly(
          'CPU Spike',
          DateTime.now(),
          'Critical',
          'CPU usage exceeded 95% threshold',
          random.nextDouble() > 0.5 ? 'Resolved' : 'Investigating',
        ));
        if (_anomalies.length > 10) _anomalies.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Predictive Analytics'),
        backgroundColor: Colors.deepPurple.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.timeline), text: 'Forecast'),
            Tab(icon: Icon(Icons.warning), text: 'Anomalies'),
            Tab(icon: Icon(Icons.trending_up), text: 'Trends'),
            Tab(icon: Icon(Icons.model_training), text: 'Models'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildForecastTab(),
          _buildAnomaliesTab(),
          _buildTrendsTab(),
          _buildModelsTab(),
        ],
      ),
    );
  }

  Widget _buildForecastTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade900, Colors.blue.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('Current Prediction', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _currentPrediction / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade800,
                      color: Colors.white,
                    ),
                  ),
                  Text('${_currentPrediction.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text('±${_confidenceInterval.toStringAsFixed(1)}% Confidence', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('Model Accuracy: ${_forecastAccuracy.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Time Series Forecast', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade800)),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                        if (value.toInt() % 5 == 0 && value < _historicalData.length) {
                          return Text('${_historicalData[value.toInt()].time.day}', style: const TextStyle(color: Colors.grey));
                        }
                        return const Text('');
                      })),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _historicalData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
                        isCurved: true,
                        color: Colors.cyan,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: _forecastData.asMap().entries.map((e) => FlSpot((_historicalData.length + e.key).toDouble(), e.value.value)).toList(),
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        dashedStroke: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend('Historical', Colors.cyan),
                  const SizedBox(width: 16),
                  _buildLegend('Forecast', Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 2, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildAnomaliesTab() {
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
            children: [
              const Text('Detection Threshold:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: _anomalyThreshold,
                  onChanged: (v) => setState(() => _anomalyThreshold = v),
                  activeColor: Colors.red,
                ),
              ),
              Text('${(_anomalyThreshold * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.red)),
              Switch(
                value: _isMonitoring,
                onChanged: (v) {
                  setState(() => _isMonitoring = v);
                  if (v) _detectAnomalies();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _anomalies.length,
            itemBuilder: (ctx, i) {
              final anomaly = _anomalies[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(left: BorderSide(color: anomaly.severity == 'Critical' ? Colors.red : Colors.orange, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: anomaly.severity == 'Critical' ? Colors.red : Colors.orange),
                        const SizedBox(width: 8),
                        Text(anomaly.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: anomaly.status == 'Resolved' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(anomaly.status, style: TextStyle(color: anomaly.status == 'Resolved' ? Colors.green : Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(anomaly.description, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
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

  Widget _buildTrendsTab() {
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
                const Text('Trend Analysis', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._trends.map((trend) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            trend.direction == 'up' ? Icons.trending_up : 
                            trend.direction == 'down' ? Icons.trending_down : Icons.trending_flat,
                            color: trend.direction == 'up' ? Colors.green : 
                                   trend.direction == 'down' ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(trend.name, style: const TextStyle(color: Colors.white))),
                          Text('${trend.change.abs().toStringAsFixed(1)}%', 
                            style: TextStyle(color: trend.direction == 'up' ? Colors.green : 
                                           trend.direction == 'down' ? Colors.red : Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: trend.change.abs() / 20,
                        backgroundColor: Colors.grey.shade800,
                        color: trend.direction == 'up' ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                )),
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
              children: [
                const Text('Trend Strengths', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._trendStrengths.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(width: 80, child: Text(entry.key, style: const TextStyle(color: Colors.white70))),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: entry.value,
                          backgroundColor: Colors.grey.shade800,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${(entry.value * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.cyan)),
                    ],
                  ),
                )),
              ],
            ),
          ),
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
          child: DropdownButtonFormField<String>(
            value: _selectedModel,
            items: _models.map((model) => DropdownMenuItem(value: model.name, child: Text(model.name))).toList(),
            onChanged: (v) => setState(() => _selectedModel = v!),
            decoration: const InputDecoration(
              labelText: 'Select Model',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _models.length,
            itemBuilder: (ctx, i) {
              final model = _models[i];
              return Card(
                color: Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: model.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(model.icon, color: model.color),
                  ),
                  title: Text(model.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${model.developer} • Accuracy: ${model.accuracy}%', style: const TextStyle(color: Colors.grey)),
                  trailing: ElevatedButton(
                    onPressed: () => _trainModel(model),
                    style: ElevatedButton.styleFrom(backgroundColor: model.color),
                    child: const Text('Train'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _trainModel(PredictionModel model) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Training ${model.name}'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(),
            SizedBox(height: 8),
            Text('Training in progress...', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
      ),
    );
    
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${model.name} trained successfully!')),
      );
    });
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

class TimeSeriesData {
  final DateTime time;
  double value;

  TimeSeriesData(this.time, this.value);
}

class Anomaly {
  final String name;
  final DateTime time;
  final String severity;
  final String description;
  final String status;

  Anomaly(this.name, this.time, this.severity, this.description, this.status);
}

class Trend {
  final String name;
  final String direction;
  final double change;
  final Color color;

  Trend(this.name, this.direction, this.change, this.color);
}

class PredictionModel {
  final String name;
  final String developer;
  final double accuracy;
  final IconData icon;
  final Color color;

  PredictionModel(this.name, this.developer, this.accuracy, this.icon, this.color);
}
