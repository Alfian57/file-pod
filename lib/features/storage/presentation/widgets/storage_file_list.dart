import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/services/file_download_service.dart';
import 'package:file_pod/features/storage/presentation/utils/file_formatter.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/delete_file_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/file_options_bottom_sheet.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/rename_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/share_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/empty_states/empty_files_widget.dart';
import 'package:file_pod/features/storage/presentation/widgets/file_preview_handler.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/file_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageFileList extends ConsumerWidget {
  const StorageFileList({super.key});

  Future<void> _handleFileOptions(
    BuildContext context,
    WidgetRef ref,
    String fileId,
    String fileName,
  ) async {
    final action = await FileOptionsBottomSheet.show(context: context);

    if (!context.mounted || action == null) return;

    switch (action) {
      case FileAction.download:
        await FileDownloadService.downloadFile(
          context: context,
          ref: ref,
          fileId: fileId,
          fileName: fileName,
        );
        break;
      case FileAction.share:
        final password = await ShareDialog.show(
          context: context,
          title: 'Share File',
        );

        if (!context.mounted || password == null) return;

        final shareResponse = await ref
            .read(storageControllerProvider.notifier)
            .shareFile(fileId, password.isEmpty ? null : password);

        if (!context.mounted) return;

        if (shareResponse != null) {
          ShareDialog.showShareResult(
            context: context,
            shareUrl: shareResponse.shareUrl,
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to share file')));
        }
        break;
      case FileAction.rename:
        // Use renamed RenameDialog (need to import)
        // I haven't imported it yet. I need to add import.
        // Assuming RenameDialog is imported.
        // Wait, I can't assume. I need to add import line.
        // But replace_file_content works on chunks. I will add import in separate call if needed.
        // But I can try to use fully qualified if not? No.
        // I will add the logic, then check for imports.
        
        // Actually, I can rely on auto-import? No.
        // I'll assume RenameDialog is available or I will add import in another step.
        // Let's write the logic first.
        
        final newName = await RenameDialog.show(
            context: context,
            currentName: fileName,
            type: 'File',
        );
        
        if (!context.mounted || newName == null || newName == fileName) return;
        
        await ref
            .read(storageControllerProvider.notifier)
            .renameFile(fileId, newName);
            
        // Refresh?
        ref.read(storageControllerProvider.notifier).getStorage();
        break;
      case FileAction.delete:
        await DeleteFileDialog.show(
          context: context,
          ref: ref,
          fileId: fileId,
          fileName: fileName,
          onSuccess: () {
            ref.read(storageControllerProvider.notifier).getStorage();
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageControllerProvider);
    final storage = storageState.storage;

    if (storage == null || storage.files.isEmpty) {
      return const EmptyFilesWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < storage.files.length; i++) ...[
          FileItem(
            fileName: storage.files[i].originalName,
            fileDate: FileFormatter.formatDate(storage.files[i].createdAt),
            fileSize: FileFormatter.formatFileSize(storage.files[i].sizeBytes),
            onMorePressed: () => _handleFileOptions(
              context,
              ref,
              storage.files[i].id,
              storage.files[i].originalName,
            ),
            onTap: () => FilePreviewHandler.showPreview(
              context: context,
              file: storage.files[i],
            ),
          ),
          if (i < storage.files.length - 1)
            const Divider(height: 1, thickness: 1),
        ],
      ],
    );
  }
}
