import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_detail_screen.dart';
import 'package:file_pod/features/storage/presentation/utils/file_formatter.dart';
import 'package:file_pod/features/storage/presentation/utils/folder_color_provider.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/delete_folder_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/folder_options_bottom_sheet.dart';
import 'package:file_pod/features/storage/presentation/widgets/empty_states/empty_folders_widget.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/folder_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageDetailFolderGrid extends ConsumerWidget {
  const StorageDetailFolderGrid({super.key, required this.parentFolderId});

  final String parentFolderId;

  Future<void> _handleFolderOptions(
    BuildContext context,
    WidgetRef ref,
    String folderId,
    String folderName,
  ) async {
    final action = await FolderOptionsBottomSheet.show(context: context);

    if (!context.mounted || action == null) return;

    switch (action) {
      case FolderAction.delete:
        await DeleteFolderDialog.show(
          context: context,
          ref: ref,
          folderId: folderId,
          folderName: folderName,
          onSuccess: () {
            ref
                .read(storageControllerProvider.notifier)
                .getStorageDetail(parentFolderId);
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageControllerProvider);
    final storageDetail = storageState.storageDetail;

    if (storageDetail == null || storageDetail.folders.isEmpty) {
      return const EmptyFoldersWidget();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.45,
      ),
      itemCount: storageDetail.folders.length,
      itemBuilder: (context, index) {
        final folder = storageDetail.folders[index];
        final colors = FolderColorProvider.getColorForIndex(index);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StorageDetailScreen(
                  folderId: folder.id,
                  folderName: folder.name,
                ),
              ),
            );
          },
          child: FolderCard(
            title: folder.name,
            date: FileFormatter.formatDate(folder.createdAt),
            bgColor: colors.background,
            iconColor: colors.icon,
            textColor: colors.text,
            onMorePressed: () =>
                _handleFolderOptions(context, ref, folder.id, folder.name),
          ),
        );
      },
    );
  }
}
