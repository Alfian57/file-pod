import 'package:file_pod/features/storage/presentation/widgets/folder_grid.dart';
import 'package:file_pod/features/storage/presentation/widgets/folder_header.dart';
import 'package:file_pod/features/storage/presentation/widgets/recent_upload_header.dart';
import 'package:file_pod/features/storage/presentation/widgets/recent_upload_list.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class StorageDetailScreen extends StatelessWidget {
  const StorageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.textPrimary,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Storage Detail', style: theme.textTheme.headlineSmall),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FolderHeader(),
            const SizedBox(height: 12),
            FolderGrid(),
            const SizedBox(height: 28),
            RecentUploadHeader(),
            const SizedBox(height: 12),
            RecentUploadList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
