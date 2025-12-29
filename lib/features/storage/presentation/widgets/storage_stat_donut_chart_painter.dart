import 'dart:math' as math;
import 'package:flutter/material.dart';

class ChartData {
  final Color color;
  final double value;
  final String? label;

  const ChartData({required this.color, required this.value, this.label});
}

class StorageStatDonutChartPainter extends CustomPainter {
  final List<ChartData> data;

  StorageStatDonutChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final innerRadius = radius * 0.6;
    final strokeWidth = radius - innerRadius;

    if (data.isEmpty) return;

    double total = data.fold(0.0, (sum, item) => sum + item.value);
    if (total == 0) return;

    // Gap angle between segments (in radians, ~2 degrees)
    const double gapAngle = 0.04;
    // Minimum visible angle for small segments (~15 degrees)
    const double minAngle = math.pi / 12;
    
    // Calculate base angles proportionally
    List<double> angles = data.map((item) {
      return (item.value / total) * 2 * math.pi;
    }).toList();
    
    // Ensure minimum visibility for non-zero values
    for (int i = 0; i < angles.length; i++) {
      if (data[i].value > 0 && angles[i] < minAngle) {
        angles[i] = minAngle;
      }
    }
    
    // Normalize to fit in 2*pi (minus gaps)
    double totalGapAngle = data.length * gapAngle;
    double angleSum = angles.fold(0.0, (sum, a) => sum + a);
    double availableAngle = 2 * math.pi - totalGapAngle;
    
    if (angleSum > 0) {
      double scale = availableAngle / angleSum;
      for (int i = 0; i < angles.length; i++) {
        angles[i] *= scale;
      }
    }

    double startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = angles[i];
      
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (radius + innerRadius) / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(StorageStatDonutChartPainter oldDelegate) => true;
}
