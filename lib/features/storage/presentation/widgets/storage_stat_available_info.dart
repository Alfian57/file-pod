import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class StorageStatAvailableInfo extends StatelessWidget {
  const StorageStatAvailableInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text('Available', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          '43.36 GB',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total 128 GB',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
