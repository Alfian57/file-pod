import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageFolderSearch extends ConsumerStatefulWidget {
  const StorageFolderSearch({super.key});

  @override
  ConsumerState<StorageFolderSearch> createState() => _StorageFolderSearchState();
}

class _StorageFolderSearchState extends ConsumerState<StorageFolderSearch> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current state if any
    final currentQuery = ref.read(storageControllerProvider).searchQuery;
    if (currentQuery != null) {
      _searchController.text = currentQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final storageState = ref.watch(storageControllerProvider);
    final isFiltered = storageState.filterType != null;

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withAlpha(40)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, size: 22, color: Color(0xFF6B6F76)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Folder',
                      hintStyle: textTheme.titleSmall?.copyWith(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    style: textTheme.titleSmall,
                    onChanged: (value) {
                      ref
                          .read(storageControllerProvider.notifier)
                          .setSearchQuery(value);
                    },
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                   GestureDetector(
                     onTap: () {
                       _searchController.clear();
                       ref
                           .read(storageControllerProvider.notifier)
                           .setSearchQuery('');
                     },
                     child: const Icon(Icons.close, size: 18, color: Colors.grey),
                   ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _showFilterSheet,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isFiltered ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isFiltered 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey.withAlpha(40),
              ),
            ),
            child: Icon(
              Icons.tune, // Filter icon
              color: isFiltered ? Colors.white : const Color(0xFF6B6F76),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterBottomSheet extends ConsumerWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(storageControllerProvider).filterType;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Type',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildFilterOption(
            context,
            ref,
            label: 'Images',
            value: 'image',
            isSelected: currentFilter == 'image',
            icon: Icons.image,
          ),
          _buildFilterOption(
            context,
            ref,
            label: 'Videos',
            value: 'video',
            isSelected: currentFilter == 'video',
            icon: Icons.videocam,
          ),
          _buildFilterOption(
            context,
            ref,
            label: 'Documents',
            value: 'document',
            isSelected: currentFilter == 'document',
            icon: Icons.description,
          ),
          if (currentFilter != null) ...[
             const Padding(
               padding: EdgeInsets.symmetric(vertical: 8.0),
               child: Divider(),
             ),
             ListTile(
              leading: const Icon(Icons.clear_all, color: Colors.red),
              title: const Text('Clear Filters', style: TextStyle(color: Colors.red)),
              onTap: () {
                ref.read(storageControllerProvider.notifier).setFilterType(null);
                Navigator.pop(context);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required String value,
    required bool isSelected,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
      onTap: () {
        ref.read(storageControllerProvider.notifier).setFilterType(value);
        Navigator.pop(context);
      },
    );
  }
}
