import 'package:file_pod/features/storage/presentation/widgets/storage_folder_search.dart';
import 'package:flutter/material.dart';
import '../../../../theme.dart';
import '../widgets/storage_folder_header.dart';
import '../widgets/storage_folder_grid.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.textPrimary,
        title: Text('File Pod', style: theme.textTheme.headlineSmall),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'lib/assets/icons/union.png',
              width: 16,
              height: 16,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StorageFolderSearch(),
            const SizedBox(height: 20),
            StorageFolderHeader(),
            const SizedBox(height: 18),
            StorageFolderGrid(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
