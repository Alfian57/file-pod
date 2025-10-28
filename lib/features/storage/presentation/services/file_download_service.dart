import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/storage_controller.dart';

class FileDownloadService {
  static Future<void> downloadFile({
    required BuildContext context,
    required WidgetRef ref,
    required String fileId,
    required String fileName,
  }) async {
    _showLoadingSnackBar(context, fileName);

    try {
      final fileBytes = await ref
          .read(storageControllerProvider.notifier)
          .downloadFile(fileId);

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

      final hasPermission = await _requestStoragePermission(context);
      if (!hasPermission) return;

      final directory = await _getDownloadDirectory();
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

      final filePath = await _saveFile(directory, fileName, fileBytes);

      if (context.mounted) {
        _showSuccessDialog(context, fileName, filePath);
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

  static void _showLoadingSnackBar(BuildContext context, String fileName) {
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
  }

  static Future<bool> _requestStoragePermission(BuildContext context) async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }

    if (!status.isGranted) {
      status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
    }

    if (!status.isGranted && Platform.isAndroid) {
      if (context.mounted) {
        _showErrorDialog(
          context,
          'Permission Required',
          'Storage permission is required to download files. Please grant the permission in settings.',
        );
      }
      return false;
    }

    return true;
  }

  static Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory;
      }
      return await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      return await getDownloadsDirectory();
    }
  }

  static Future<String> _saveFile(
    Directory directory,
    String fileName,
    List<int> fileBytes,
  ) async {
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(fileBytes);
    return filePath;
  }

  static void _showSuccessDialog(
    BuildContext context,
    String fileName,
    String filePath,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Expanded(child: Text('Download Complete')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File "$fileName" has been downloaded successfully.'),
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

  static void _showErrorDialog(
    BuildContext context,
    String title,
    String message,
  ) {
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
}
