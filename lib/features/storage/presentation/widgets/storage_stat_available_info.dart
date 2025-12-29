import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class StorageStatAvailableInfo extends StatelessWidget {
  const StorageStatAvailableInfo({
    super.key,
    required this.availableBytes,
    required this.totalBytes,
  });

  final BigInt availableBytes;
  final BigInt totalBytes;

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
    final theme = Theme.of(context);

    return Column(
      children: [
        Text('Free Space', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          _formatBytes(availableBytes),
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total ${_formatBytes(totalBytes)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
