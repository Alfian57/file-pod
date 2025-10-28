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

enum FolderAction { delete }
