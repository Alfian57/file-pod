import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/screens/storage_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/folder_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageFolderGrid extends ConsumerWidget {
  const StorageFolderGrid({super.key});

  List<Color> _getFolderColors(int index) {
    final colors = [
      {
        'bg': const Color(0xFFEAF5FF),
        'icon': const Color(0xFF4B6BE6),
        'text': const Color(0xFF4B6BE6),
      },
      {
        'bg': const Color(0xFFFFF6E6),
        'icon': const Color(0xFFF5B400),
        'text': const Color(0xFFF5B400),
      },
      {
        'bg': const Color(0xFFFFEFEF),
        'icon': const Color(0xFFD94B48),
        'text': const Color(0xFFD94B48),
      },
      {
        'bg': const Color(0xFFE8FFFB),
        'icon': const Color(0xFF13C8B7),
        'text': const Color(0xFF13C8B7),
      },
    ];
    return [
      colors[index % colors.length]['bg']!,
      colors[index % colors.length]['icon']!,
      colors[index % colors.length]['text']!,
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageControllerProvider);
    final storage = storageState.storage;

    if (storage == null || storage.folders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.folder_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No folders yet',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the + button to create a folder',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
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
      itemCount: storage.folders.length,
      itemBuilder: (context, index) {
        final folder = storage.folders[index];
        final colors = _getFolderColors(index);

        return GestureDetector(
          onTap: () {
            // Navigate to folder detail
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
            date: _formatDate(folder.createdAt),
            bgColor: colors[0],
            iconColor: colors[1],
            textColor: colors[2],
            onMorePressed: () =>
                _showFolderOptions(context, ref, folder.id, folder.name),
          ),
        );
      },
    );
  }

  void _showFolderOptions(
    BuildContext context,
    WidgetRef ref,
    String folderId,
    String folderName,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Folder',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteFolder(context, ref, folderId, folderName);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteFolder(
    BuildContext context,
    WidgetRef ref,
    String folderId,
    String folderName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: Text('Are you sure you want to delete "$folderName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(storageControllerProvider.notifier)
                  .deleteFolder(folderId);
              // Refresh storage after deleting folder
              ref.read(storageControllerProvider.notifier).getStorage();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
