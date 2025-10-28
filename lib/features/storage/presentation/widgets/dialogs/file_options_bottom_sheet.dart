import 'package:flutter/material.dart';

class FileOptionsBottomSheet {
  static Future<FileAction?> show({required BuildContext context}) async {
    return showModalBottomSheet<FileAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download'),
              onTap: () => Navigator.pop(context, FileAction.download),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context, FileAction.delete),
            ),
          ],
        ),
      ),
    );
  }
}

enum FileAction { download, delete }
