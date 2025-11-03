import 'package:file_pod/features/storage/presentation/widgets/storage_sort_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageFolderHeader extends ConsumerWidget {
  const StorageFolderHeader({super.key, required this.onSortChanged});

  final VoidCallback onSortChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('My Folders', style: theme.textTheme.headlineSmall),
        Row(children: [StorageSortButton(onSortChanged: onSortChanged)]),
      ],
    );
  }
}
