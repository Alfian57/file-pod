import 'package:file_pod/core/widgets/ui/app_button.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_statistics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageStatExportButton extends ConsumerWidget {
  const StorageStatExportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: () {
          ref.read(storageStatisticsProvider.notifier).exportStatistics();
        },
        label: 'Export Details',
        icon: Icons.download_outlined,
        iconOnRight: true,
      ),
    );
  }
}
