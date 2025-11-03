import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:file_pod/features/storage/presentation/utils/file_formatter.dart';
import 'package:file_pod/theme.dart';
import 'package:flutter/material.dart';

class ProfileStorageInfo extends StatelessWidget {
  const ProfileStorageInfo({super.key, this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storageUsed = user?.storageUsedBytes ?? 0;
    final storageQuota = user?.storageQuotaBytes ?? 0;
    final storagePercent = storageQuota > 0
        ? (storageUsed / storageQuota)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary,
            AppTheme.primary.withAlpha((0.8 * 255).round()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha((0.3 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Storage Usage',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.onPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FileFormatter.formatFileSize(storageUsed.toString()),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'of ${FileFormatter.formatFileSize(storageQuota.toString())}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onPrimary.withAlpha((0.8 * 255).round()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: storagePercent,
              minHeight: 8,
              backgroundColor: AppTheme.onPrimary.withAlpha(
                (0.3 * 255).round(),
              ),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.onPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(storagePercent * 100).toStringAsFixed(1)}% used',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onPrimary.withAlpha((0.8 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }
}
