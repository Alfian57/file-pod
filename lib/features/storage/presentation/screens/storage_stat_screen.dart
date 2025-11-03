import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/core/widgets/shared/storage_bottom_navigation_bar.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_donut_chart.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_donut_chart_painter.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_export_button.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_list.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_available_info.dart';
import 'package:flutter/material.dart';

class StorageStatScreen extends StatelessWidget {
  const StorageStatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: StorageAppBar(title: "Storage Statistics"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            StorageStatDonutChart(
              data: [
                ChartData(color: Color(0xFF2C3080), value: 38.66),
                ChartData(color: Color(0xFF567DF4), value: 24.80),
                ChartData(color: Color(0xFF4ECB71), value: 12.60),
                ChartData(color: Color(0xFFFFC542), value: 6.57),
                ChartData(color: Color(0xFFFF974A), value: 2.01),
              ],
            ),

            const SizedBox(height: 32),
            StorageStatAvailableInfo(),
            const SizedBox(height: 40),
            StorageStatList(),
            const SizedBox(height: 40),
            StorageStatExportButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: StorageBottomNavigationBar(),
    );
  }
}
