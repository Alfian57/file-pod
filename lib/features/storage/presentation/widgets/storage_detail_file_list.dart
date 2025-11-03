import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/services/file_download_service.dart';
import 'package:file_pod/features/storage/presentation/utils/file_formatter.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/delete_file_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/file_options_bottom_sheet.dart';
import 'package:file_pod/features/storage/presentation/widgets/empty_states/empty_files_widget.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/file_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageDetailFileList extends ConsumerWidget {
  const StorageDetailFileList({super.key, required this.folderId});

  final String folderId;

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
      case FileAction.delete:
        await DeleteFileDialog.show(
          context: context,
          ref: ref,
          fileId: fileId,
          fileName: fileName,
          onSuccess: () {
            ref
                .read(storageControllerProvider.notifier)
                .getStorageDetail(folderId);
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageControllerProvider);
    final storageDetail = storageState.storageDetail;

    if (storageDetail == null || storageDetail.files.isEmpty) {
      return const EmptyFilesWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < storageDetail.files.length; i++) ...[
          FileItem(
            fileName: storageDetail.files[i].originalName,
            fileDate: FileFormatter.formatDate(
              storageDetail.files[i].createdAt,
            ),
            fileSize: FileFormatter.formatFileSize(
              storageDetail.files[i].sizeBytes,
            ),
            onMorePressed: () => _handleFileOptions(
              context,
              ref,
              storageDetail.files[i].id,
              storageDetail.files[i].originalName,
            ),
          ),
          if (i < storageDetail.files.length - 1)
            const Divider(height: 1, thickness: 1),
        ],
      ],
    );
  }
}
