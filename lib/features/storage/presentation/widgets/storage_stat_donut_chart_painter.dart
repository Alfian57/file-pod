import 'dart:math' as math;
import 'package:flutter/material.dart';

class ChartData {
  final Color color;
  final double value;

  const ChartData({required this.color, required this.value});
}

class StorageStatDonutChartPainter extends CustomPainter {
  final List<ChartData> data;

  StorageStatDonutChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final innerRadius = radius * 0.55;

    double total = data.fold(0, (sum, item) => sum + item.value);
    double startAngle = -math.pi / 2;

    for (var item in data) {
      final sweepAngle = (item.value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius - innerRadius
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (radius + innerRadius) / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(StorageStatDonutChartPainter oldDelegate) => false;
}
