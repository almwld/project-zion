import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class SpiderChart extends StatefulWidget {
  const SpiderChart({super.key});

  @override
  State<SpiderChart> createState() => _SpiderChartState();
}

class _SpiderChartState extends State<SpiderChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // مقاييس الأداء الاستراتيجي (6 محاور)
  List<SpiderMetric> _metrics = [];
  Timer? _updateTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initMetrics();
    _initAnimation();
    _startRealTimeUpdates();
  }

  void _initMetrics() {
    _metrics = [
      SpiderMetric('CPU', 0.35, Colors.cyan),
      SpiderMetric('RAM', 0.45, Colors.green),
      SpiderMetric('Network', 0.25, Colors.orange),
      SpiderMetric('Disk', 0.30, Colors.purple),
      SpiderMetric('Thermal', 0.20, Colors.red),
      SpiderMetric('Battery', 0.65, Colors.yellow),
    ];
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  void _startRealTimeUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        for (var metric in _metrics) {
          metric.value = (metric.value + (_random.nextDouble() - 0.5) * 0.1).clamp(0.05, 0.95);
        }
      });
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(280, 280),
          painter: SpiderChartPainter(_metrics, _animation.value),
        );
      },
    );
  }
}

class SpiderMetric {
  final String name;
  double value;
  final Color color;

  SpiderMetric(this.name, this.value, this.color);
}

class SpiderChartPainter extends CustomPainter {
  final List<SpiderMetric> metrics;
  final double animationValue;

  SpiderChartPainter(this.metrics, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;
    final angles = List.generate(metrics.length, (i) => i * 2 * pi / metrics.length - pi / 2);
    
    // رسم الشبكة الخلفية (5 حلقات)
    for (int level = 1; level <= 5; level++) {
      final r = radius * level / 5;
      final paint = Paint()
        ..color = Colors.grey.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(center, r, paint);
    }
    
    // رسم الخطوط القطرية
    for (var angle in angles) {
      final end = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
      final paint = Paint()
        ..color = Colors.grey.withOpacity(0.3)
        ..strokeWidth = 0.5;
      canvas.drawLine(center, end, paint);
    }
    
    // رسم نقاط البيانات (مع تأثير الأنيميشن)
    final points = <Offset>[];
    for (int i = 0; i < metrics.length; i++) {
      final value = metrics[i].value * animationValue;
      final r = radius * value;
      final x = center.dx + r * cos(angles[i]);
      final y = center.dy + r * sin(angles[i]);
      points.add(Offset(x, y));
    }
    
    // رسم المنطقة الداخلية
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      
      final fillPaint = Paint()
        ..color = Colors.cyan.withOpacity(0.25)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
      
      final strokePaint = Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, strokePaint);
    }
    
    // رسم نقاط البيانات وتسمياتها
    for (int i = 0; i < metrics.length; i++) {
      final point = points[i];
      final value = metrics[i].value * animationValue;
      final isHighlight = value > 0.6;
      
      // النقاط
      final pointPaint = Paint()
        ..color = isHighlight ? metrics[i].color : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, isHighlight ? 6 : 4, pointPaint);
      
      // التسميات
      final labelAngle = angles[i];
      final labelRadius = radius + 20;
      final labelX = center.dx + labelRadius * cos(labelAngle);
      final labelY = center.dy + labelRadius * sin(labelAngle);
      
      final textSpan = TextSpan(
        text: metrics[i].name,
        style: TextStyle(
          color: metrics[i].color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(labelX - textPainter.width / 2, labelY - 8));
      
      // عرض النسبة المئوية
      final percentSpan = TextSpan(
        text: '${(metrics[i].value * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 8,
        ),
      );
      final percentPainter = TextPainter(text: percentSpan, textDirection: TextDirection.ltr);
      percentPainter.layout();
      percentPainter.paint(canvas, Offset(labelX - percentPainter.width / 2, labelY + 4));
    }
    
    // رسم المركز
    final centerPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
