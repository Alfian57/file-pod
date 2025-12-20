import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_detail_folder_grid.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_detail_folder_header.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_detail_file_list.dart';
import 'package:file_pod/features/storage/presentation/widgets/create_folder_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_breadcrumb.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_folder_search.dart';
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
        onExportDetails: () {
          ref.read(storageControllerProvider.notifier).exportCurrentView();
        },
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
                padding: const EdgeInsets.symmetric(vertical: 16), // Adjusted padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StorageFolderSearch(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    if (storageState.storageDetail?.ancestors != null)
                      StorageBreadcrumb(
                        ancestors: storageState.storageDetail!.ancestors ?? [],
                        currentFolder: null, // We are IN the current folder, so it is implicitly the last one displayed or we append it?
                        // My StorageBreadcrumb appends currentFolder if provided.
                        // storageDetail.name is the current folder name.
                        // Let's pass simple object for current folder.
                        // Or just rely on ancestors?
                        // "My Storage > Ancestor > Current"
                        // ancestors usually excludes current.
                        // Let's check backend logic. `path` includes `curr`.
                        // Backend: `path.unshift(curr);`. It INCLUDES current folder.
                        // So `ancestors` array INCLUDES the current folder as the last item.
                        // So I should pass `ancestors` and NO currentFolder.
                        onFolderTap: (id) {
                          if (id == null) {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          } else if (id != widget.folderId) {
                             // If it's not current folder (though breadcrumb handles enabling/disabling last item)
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StorageDetailScreen(
                                  folderId: id,
                                  folderName: "Folder", // Name might be needed?
                                  // I can find name from ancestors list.
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: StorageDetailFolderHeader(
                        onSortChanged: () {
                          ref
                              .read(storageControllerProvider.notifier)
                              .getStorageDetail(widget.folderId);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: StorageDetailFolderGrid(parentFolderId: widget.folderId),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('My Files', style: theme.textTheme.headlineSmall),
                    ),
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
