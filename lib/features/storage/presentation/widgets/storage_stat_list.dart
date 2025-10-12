import 'package:file_pod/features/storage/presentation/widgets/storage_stat_item.dart';
import 'package:flutter/material.dart';

class StorageStatList extends StatelessWidget {
  const StorageStatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StorageStatItem(
          color: const Color(0xFF2C3080),
          title: 'Design Files',
          size: '38.66 GB',
          percentage: 0.302,
        ),
        const SizedBox(height: 20),
        StorageStatItem(
          color: const Color(0xFFFFC542),
          title: 'Images',
          size: '24.80 GB',
          percentage: 0.194,
        ),
        const SizedBox(height: 20),
        StorageStatItem(
          color: const Color(0xFF4ECB71),
          title: 'Video',
          size: '12.60 GB',
          percentage: 0.098,
        ),
        const SizedBox(height: 20),
        StorageStatItem(
          color: const Color(0xFF567DF4),
          title: 'Documents',
          size: '06.57 GB',
          percentage: 0.051,
        ),
        const SizedBox(height: 20),
        StorageStatItem(
          color: const Color(0xFFFF974A),
          title: 'Others',
          size: '2.01 GB',
          percentage: 0.016,
        ),
      ],
    );
  }
}
