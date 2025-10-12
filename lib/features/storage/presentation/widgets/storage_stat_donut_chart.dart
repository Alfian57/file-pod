import 'package:file_pod/features/storage/presentation/widgets/storage_stat_donut_chart_painter.dart';
import 'package:flutter/material.dart';

class StorageStatDonutChart extends StatelessWidget {
  const StorageStatDonutChart({super.key, required this.data});

  final List<ChartData> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomPaint(
        size: Size(280, 280),
        painter: StorageStatDonutChartPainter(data: data),
      ),
    );
  }
}
