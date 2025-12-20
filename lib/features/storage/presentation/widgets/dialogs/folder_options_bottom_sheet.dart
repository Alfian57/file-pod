import 'package:flutter/material.dart';

class FolderOptionsBottomSheet {
  static Future<FolderAction?> show({required BuildContext context}) async {
    return showModalBottomSheet<FolderAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => Navigator.pop(context, FolderAction.share),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () => Navigator.pop(context, FolderAction.rename),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Folder',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.pop(context, FolderAction.delete),
            ),
          ],
        ),
      ),
    );
  }
}

enum FolderAction { share, rename, delete }
