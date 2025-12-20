import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/widgets/storage_folder_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import '../../../../theme.dart';
import '../widgets/storage_folder_header.dart';
import '../widgets/storage_folder_grid.dart';
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
    final theme = Theme.of(context);
    final storageState = ref.watch(storageControllerProvider);

    // Show error message if any
    // Show error message if any
    ref.listen(storageControllerProvider, (previous, next) {
      if (next.error != null) {
        // Only show technical errors in debug mode or if it's a user-friendly error
        // For now, let's show all but styled nicer.
        // User asked: "alert untuk debugging tidak muncul saat aplikasi rilis"
        // We can check if kDebugMode, but we also want to show crucial errors to users.
        // Let's assume 'error' contains technical details often.
        // We will show a friendly message for users, and detail only in debug.
        
        // Note: kDebugMode needs import 'package:flutter/foundation.dart';
        
        final isDebug = false; // logic to check kDebugMode or just rely on kDebugMode import
        // If we import foundation, we can use kDebugMode.
        // I will add import later.
        
        if (next.error!.contains("DioException") && !kDebugMode) {
           // Suppress technical network errors in release, maybe show generic "Connection Error"
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong. Please check your connection."),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
           AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Error',
            desc: next.error,
            btnOkOnPress: () {
               ref.read(storageControllerProvider.notifier).clearError();
            },
          ).show();
        }
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: StorageAppBar(title: "File Pod"),
      body: Column(
        children: [
          if (storageState.isUploading)
            LinearProgressIndicator(value: storageState.uploadProgress),
          Expanded(
            child: storageState.isLoading && storageState.storage == null
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(storageControllerProvider.notifier)
                          .getStorage();
                    },
                    child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StorageFolderSearch(),
                    const SizedBox(height: 20),
                    StorageFolderHeader(
                      onSortChanged: () {
                        ref
                            .read(storageControllerProvider.notifier)
                            .getStorage();
                      },
                    ),
                    const SizedBox(height: 18),
                    StorageFolderGrid(),
                    const SizedBox(height: 28),
                    Text('My Files', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    StorageFileList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
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
