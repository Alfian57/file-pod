import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/storage_controller.dart';

class DeleteFolderDialog {
  static Future<void> show({
    required BuildContext context,
    required WidgetRef ref,
    required String folderId,
    required String folderName,
    required VoidCallback onSuccess,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: Text('Are you sure you want to delete "$folderName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(storageControllerProvider.notifier).deleteFolder(folderId);
      onSuccess();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Folder deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
