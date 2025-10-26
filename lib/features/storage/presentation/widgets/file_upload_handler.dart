import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';

class FileUploadHandler {
  static Future<void> uploadFile({
    required BuildContext context,
    required WidgetRef ref,
    required String? folderId,
    required VoidCallback onSuccess,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      final file = result.files.first;
      if (file.path == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to access file path'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Show uploading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uploading ${file.name}...'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Upload file
      await ref
          .read(storageControllerProvider.notifier)
          .uploadFile(file.path!, folderId);

      // Call success callback to refresh
      onSuccess();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${file.name} uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
