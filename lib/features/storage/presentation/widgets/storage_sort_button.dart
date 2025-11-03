import 'package:file_pod/features/storage/domain/enums/sort_options.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_pod/theme.dart';

class StorageSortButton extends ConsumerWidget {
  const StorageSortButton({super.key, required this.onSortChanged});

  final VoidCallback onSortChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageControllerProvider);

    return IconButton(
      icon: const Icon(Icons.sort, color: AppTheme.textPrimary),
      onPressed: () => _showSortBottomSheet(context, ref, storageState),
    );
  }

  void _showSortBottomSheet(
    BuildContext context,
    WidgetRef ref,
    StorageState currentState,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildSortOption(
              context: context,
              ref: ref,
              label: 'Name',
              sortBy: SortBy.name,
              isSelected: currentState.sortBy == SortBy.name,
            ),
            const SizedBox(height: 12),
            _buildSortOption(
              context: context,
              ref: ref,
              label: 'Date Created',
              sortBy: SortBy.createdAt,
              isSelected: currentState.sortBy == SortBy.createdAt,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildOrderOption(
              context: context,
              ref: ref,
              label: 'Ascending',
              icon: Icons.arrow_upward,
              sortOrder: SortOrder.asc,
              isSelected: currentState.sortOrder == SortOrder.asc,
            ),
            const SizedBox(height: 12),
            _buildOrderOption(
              context: context,
              ref: ref,
              label: 'Descending',
              icon: Icons.arrow_downward,
              sortOrder: SortOrder.desc,
              isSelected: currentState.sortOrder == SortOrder.desc,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required SortBy sortBy,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ref.read(storageControllerProvider.notifier).setSortBy(sortBy);
        Navigator.pop(context);
        onSortChanged();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withAlpha(20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.textSecondary.withAlpha(40),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderOption({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required IconData icon,
    required SortOrder sortOrder,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ref.read(storageControllerProvider.notifier).setSortOrder(sortOrder);
        Navigator.pop(context);
        onSortChanged();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withAlpha(20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.textSecondary.withAlpha(40),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
