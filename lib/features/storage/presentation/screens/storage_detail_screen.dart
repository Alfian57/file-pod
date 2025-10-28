import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_detail_folder_grid.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_detail_folder_header.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_detail_file_header.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_detail_file_list.dart';
import 'package:file_pod/features/storage/presentation/widgets/create_folder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/storage_action_menu.dart';
import '../widgets/file_upload_handler.dart';

class StorageDetailScreen extends ConsumerStatefulWidget {
  const StorageDetailScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  final String folderId;
  final String folderName;

  @override
  ConsumerState<StorageDetailScreen> createState() =>
      _StorageDetailScreenState();
}

class _StorageDetailScreenState extends ConsumerState<StorageDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load storage detail when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(storageControllerProvider.notifier)
          .getStorageDetail(widget.folderId);
    });
  }

  void _showActionMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StorageActionMenu(
        onCreateFolder: _showCreateFolderDialog,
        onUploadFile: _uploadFile,
      ),
    );
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateFolderDialog(
        parentFolderId: widget.folderId,
        onSuccess: () {
          ref
              .read(storageControllerProvider.notifier)
              .getStorageDetail(widget.folderId);
        },
      ),
    );
  }

  void _uploadFile() {
    FileUploadHandler.uploadFile(
      context: context,
      ref: ref,
      folderId: widget.folderId,
      onSuccess: () {
        ref
            .read(storageControllerProvider.notifier)
            .getStorageDetail(widget.folderId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storageState = ref.watch(storageControllerProvider);

    // Show error message if any
    ref.listen(storageControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: StorageAppBar(title: widget.folderName),
      body: storageState.isLoading && storageState.storageDetail == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(storageControllerProvider.notifier)
                    .getStorageDetail(widget.folderId);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StorageDetailFolderHeader(),
                    const SizedBox(height: 12),
                    StorageDetailFolderGrid(parentFolderId: widget.folderId),
                    const SizedBox(height: 28),
                    StorageDetailFileHeader(),
                    const SizedBox(height: 12),
                    StorageDetailFileList(folderId: widget.folderId),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionMenu,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
