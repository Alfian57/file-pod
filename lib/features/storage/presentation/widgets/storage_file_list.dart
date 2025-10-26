import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/recent_upload_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageFileList extends ConsumerWidget {
  const StorageFileList({super.key});

  String _formatFileSize(String? sizeBytes) {
    if (sizeBytes == null) return 'Unknown';

    try {
      final bytes = int.parse(sizeBytes);
      if (bytes < 1024) return '${bytes}B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
      if (bytes < 1024 * 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
      }
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    } catch (e) {
      return sizeBytes;
    }
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

  void _showFileOptions(
    BuildContext context,
    WidgetRef ref,
    String fileId,
    String fileName,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement download functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download feature coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteFile(context, ref, fileId, fileName);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteFile(
    BuildContext context,
    WidgetRef ref,
    String fileId,
    String fileName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "$fileName"?'),
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
                  .deleteFile(fileId);
              // Refresh storage after deleting file
              await ref.read(storageControllerProvider.notifier).getStorage();
              // Show success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageControllerProvider);
    final storage = storageState.storage;

    if (storage == null || storage.files.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.file_present_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No files uploaded yet',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < storage.files.length; i++) ...[
          RecentUploadItem(
            fileName: storage.files[i].originalName,
            fileDate: _formatDate(storage.files[i].createdAt),
            fileSize: _formatFileSize(storage.files[i].sizeBytes),
            onMorePressed: () => _showFileOptions(
              context,
              ref,
              storage.files[i].id,
              storage.files[i].originalName,
            ),
          ),
          if (i < storage.files.length - 1)
            const Divider(height: 1, thickness: 1),
        ],
      ],
    );
  }
}
