import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/core/widgets/shared/storage_bottom_navigation_bar.dart';
import 'package:file_pod/features/storage/data/models/storage_statistics_model.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_statistics_provider.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_donut_chart.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_donut_chart_painter.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_export_button.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_list.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_available_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageStatScreen extends ConsumerWidget {
  const StorageStatScreen({super.key});

  // Category colors mapping
  static const Map<String, Color> categoryColors = {
    'Design Files': Color(0xFF2C3080),
    'Images': Color(0xFFFFC542),
    'Video': Color(0xFF4ECB71),
    'Documents': Color(0xFF567DF4),
    'Others': Color(0xFFFF974A),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statisticsAsync = ref.watch(storageStatisticsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: StorageAppBar(title: "Storage Statistics"),
      body: statisticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(storageStatisticsProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (statistics) {
          if (statistics == null) {
            return const Center(child: Text('No data available'));
          }

          final chartData = _buildChartData(statistics.categories);
          final totalBytes = BigInt.parse(statistics.totalBytes);
          final availableBytes = BigInt.parse(statistics.availableBytes);

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(storageStatisticsProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  StorageStatDonutChart(data: chartData),
                  const SizedBox(height: 32),
                  StorageStatAvailableInfo(
                    availableBytes: availableBytes,
                    totalBytes: totalBytes,
                  ),
                  const SizedBox(height: 40),
                  StorageStatList(
                    categories: statistics.categories,
                    totalBytes: totalBytes,
                    categoryColors: categoryColors,
                  ),
                  const SizedBox(height: 40),
                  StorageStatExportButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: StorageBottomNavigationBar(),
    );
  }

  List<ChartData> _buildChartData(List<StorageCategoryModel> categories) {
    final List<ChartData> chartData = [];

    for (final category in categories) {
      final sizeBytes = BigInt.parse(category.sizeBytes);
      if (sizeBytes > BigInt.zero) {
        final color = categoryColors[category.category] ?? Colors.grey;
        chartData.add(ChartData(
          color: color,
          value: sizeBytes.toDouble() / (1024 * 1024 * 1024), // Convert to GB
        ));
      }
    }

    return chartData;
  }
}
