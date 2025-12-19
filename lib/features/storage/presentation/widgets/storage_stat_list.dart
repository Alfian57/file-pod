import 'package:file_pod/features/storage/data/models/storage_statistics_model.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_stat_item.dart';
import 'package:flutter/material.dart';

class StorageStatList extends StatelessWidget {
  const StorageStatList({
    super.key,
    required this.categories,
    required this.totalBytes,
    required this.categoryColors,
  });

  final List<StorageCategoryModel> categories;
  final BigInt totalBytes;
  final Map<String, Color> categoryColors;

  String _formatBytes(BigInt bytes) {
    final kb = 1024;
    final mb = kb * 1024;
    final gb = mb * 1024;

    final bytesDouble = bytes.toDouble();

    if (bytesDouble >= gb) {
      return '${(bytesDouble / gb).toStringAsFixed(2)} GB';
    } else if (bytesDouble >= mb) {
      return '${(bytesDouble / mb).toStringAsFixed(2)} MB';
    } else if (bytesDouble >= kb) {
      return '${(bytesDouble / kb).toStringAsFixed(2)} KB';
    } else {
      return '${bytes.toString()} B';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out categories with 0 bytes and sort by size descending
    final sortedCategories = categories
        .where((c) => BigInt.parse(c.sizeBytes) > BigInt.zero)
        .toList()
      ..sort((a, b) =>
          BigInt.parse(b.sizeBytes).compareTo(BigInt.parse(a.sizeBytes)));

    if (sortedCategories.isEmpty) {
      return const Center(
        child: Text('No files uploaded yet'),
      );
    }

    return Column(
      children: sortedCategories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final sizeBytes = BigInt.parse(category.sizeBytes);
        final percentage = totalBytes > BigInt.zero
            ? sizeBytes.toDouble() / totalBytes.toDouble()
            : 0.0;
        final color = categoryColors[category.category] ?? Colors.grey;

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 20),
            StorageStatItem(
              color: color,
              title: category.category,
              size: _formatBytes(sizeBytes),
              percentage: percentage,
            ),
          ],
        );
      }).toList(),
    );
  }
}
