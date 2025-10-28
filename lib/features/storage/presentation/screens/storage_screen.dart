import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_folder_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme.dart';
import '../widgets/storage_folder_header.dart';
import '../widgets/storage_folder_grid.dart';
import '../widgets/storage_file_header.dart';
import '../widgets/storage_file_list.dart';
import '../widgets/create_folder_dialog.dart';
import '../widgets/storage_action_menu.dart';
import '../widgets/file_upload_handler.dart';
import '../../../../core/widgets/shared/storage_bottom_navigation_bar.dart';

class StorageScreen extends ConsumerStatefulWidget {
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends ConsumerState<StorageScreen> {
  @override
  void initState() {
    super.initState();
    // Load storage data when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storageControllerProvider.notifier).getStorage();
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
        parentFolderId: null,
        onSuccess: () {
          ref.read(storageControllerProvider.notifier).getStorage();
        },
      ),
    );
  }

  void _uploadFile() {
    FileUploadHandler.uploadFile(
      context: context,
      ref: ref,
      folderId: null,
      onSuccess: () {
        ref.read(storageControllerProvider.notifier).getStorage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppTheme.background,
      appBar: StorageAppBar(title: "File Pod"),
      body: storageState.isLoading && storageState.storage == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(storageControllerProvider.notifier).getStorage();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StorageFolderSearch(),
                    const SizedBox(height: 20),
                    StorageFolderHeader(),
                    const SizedBox(height: 18),
                    StorageFolderGrid(),
                    const SizedBox(height: 28),
                    StorageFileHeader(),
                    const SizedBox(height: 12),
                    StorageFileList(),
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
      bottomNavigationBar: StorageBottomNavigationBar(),
    );
  }
}
