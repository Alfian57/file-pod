import 'dart:io';

import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/recent_upload_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
                _downloadFile(context, ref, fileId, fileName);
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

  Future<void> _downloadFile(
    BuildContext context,
    WidgetRef ref,
    String fileId,
    String fileName,
  ) async {
    // Show loading indicator first
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Downloading "$fileName"...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      // Download file first
      final fileBytes = await ref
          .read(storageControllerProvider.notifier)
          .downloadFile(fileId);

      // Clear loading
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }

      if (fileBytes == null) {
        if (context.mounted) {
          _showErrorDialog(
            context,
            'Download Failed',
            'Failed to download "$fileName". Please try again.',
          );
        }
        return;
      }

      // Request storage permission
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }

      // If manageExternalStorage not granted, try storage permission
      if (!status.isGranted) {
        status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }

      // Check if permission was denied
      if (!status.isGranted && Platform.isAndroid) {
        if (context.mounted) {
          _showErrorDialog(
            context,
            'Permission Required',
            'Storage permission is required to download files. Please grant the permission in settings.',
          );
        }
        return;
      }

      // Get downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null) {
        if (context.mounted) {
          _showErrorDialog(
            context,
            'Download Failed',
            'Could not access downloads directory.',
          );
        }
        return;
      }

      // Save file
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);

      if (context.mounted) {
        _showSuccessDialog(
          context,
          'Download Complete',
          'File "$fileName" has been downloaded successfully.',
          filePath,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _showErrorDialog(
          context,
          'Download Failed',
          'Error downloading "$fileName": ${e.toString()}',
        );
      }
    }
  }

  void _showSuccessDialog(
    BuildContext context,
    String title,
    String message,
    String filePath,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder_open, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      filePath,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
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
